module("ECSManager", package.seeall)


--实体flag
EEntityFlag = {
    Init = 1,
    Destroy = 99,
}

EEventType = {
    DestroyEntity = 1,
}

local EEventCacheType = {
    Entity = 1,
    System = 2
}
--
local _handle = nil
local _entityCache = {}
local _dirtyEntities = {}
local _systemClass = {}
local _systemCache = {}

local _eventQueue = {
    [EEventCacheType.Entity] = {},
    [EEventCacheType.System] = {}
}
---
--[[事件管理]]
local function dispathcEvent(cacheType,event,params)
    local info = {
        event = event,
        params = params,
    }
    table.insert(_eventQueue[cacheType], info )
end

--[[实体管理]]
function dirtyEntity(entity,flag)
    local id = entity:getID()
    _dirtyEntities[id] = _dirtyEntities[id] or {}
    _dirtyEntities[id].entity = entity
    _dirtyEntities[id].flags = _dirtyEntities[id].flags or {}
    _dirtyEntities[id].flags[flag] = true
end

function destroyEntity(entity)
    dirtyEntity(entity,EEntityFlag.Destroy)
    dispathcEvent(EEventCacheType.System,EEventType.DestroyEntity,entity)
end

function addEntity(entity)
    _entityCache[entity] = entity
    dirtyEntity(entity,EEntityFlag.Init)
end

function removeEntity(entity,isDestroy)
    if isDestroy then 
        destroyEntity(entity) 
    end
    _entityCache[entity] = nil
end

function visitEntity(func)
    for _,v in pairs(_entityCache) do
		if tolua.isnull(v) then 
			_entityCache[v] = nil
		else
			local ret = func(v)
			if ret then return ret end
		end
	end
end

function getAllEntities(exEntity)
    --有点危险,因为可能有的实体因为场景释放而释放
    local ret = {}
    visitEntity(function (v)
        if exEntity ~= v then
            table.insert( ret, v )
        end
    end)
    return ret
end

function findEntityById(id)
	return visitEntity(function(entity)
		if entity:getID() == id then
			return entity
		end
	end)
end

function findEntitiesWithTag(tag)
	local list = {}
	visitEntity(function(entity)
		if entity:getTag() == tag then
			table.insert( list, entity )
		end
	end)
	return list
end

function findEntityWithTag(tag)
	return findEntitiesWithTag(tag)[1]
end

local function _handleEntities(delay)
    local function _updateEntities()
        visitEntity(function(v)
            if not v:isCCNode() then
                v:update(delay)
            end
        end)
    end
    local function _handleEntitiesEvent()
        for _,v in ipairs(_eventQueue[EEventCacheType.Entity]) do
            ECSManager.visitSystem(function(system)
                system:_onEvent(v.event,v.params)
            end)
        end
        _eventQueue[EEventCacheType.Entity] = {}
    end
    local function _rinseEntities()
        for _,v in pairs(_dirtyEntities) do
            if v.flags[EEntityFlag.Init] then
                if not v.entity:isCCNode() then
                    v.entity:_enter()
                end
            end
            if v.flags[EEntityFlag.Destroy] then
                if not v.entity:isCCNode() then
                    v.entity:_exit()
                    v.entity:_onCleanup()
                else
                    v.entity:removeFromParent()
                end
                removeEntity(v.entity,false)
            end
        end
        _dirtyEntities = {}
    end
    _rinseEntities()
    _handleEntitiesEvent()
    _updateEntities()
end

local function _clearEntities()
    visitEntity(function(v)
        v:clear()
    end)
end

-----
--[[系统管理]]
function addSystem(system)
    local className = system:getClass()
    _systemCache[className] = system
end

function getSystem(name)
    return _systemCache[name]
end

function removeSystem(system)
    local className = system:getClass()
    _systemCache[system] = nil
end

function registerSystem(path)
    table.insert( _systemClass, {classPath = path})
end

function visitSystem(func)
    for _,v in pairs(_systemCache) do
        local ret = func(v)
        if ret then return ret end
	end
end

local function _handleSystems(delay)
    local function _updateSystems()
        visitSystem(function(v)
            v:update(delay)
        end)
    end
    local function _handleSystemsEvent()
        for _,v in ipairs(_eventQueue[EEventCacheType.System]) do
            ECSManager.visitSystem(function(system)
                system:_onEvent(v.event,v.params)
            end)
        end
        _eventQueue[EEventCacheType.System] = {}
    end
    local function _rinseSystems()
       
    end
    _updateSystems()
    _handleSystemsEvent()
    _rinseSystems()
end
local function _clearSystems()
    visitSystem(function(v)
        v:clear()
    end)
end
----

function update(delay)
    _handleSystems(delay)
    _handleEntities(delay)
    
end


function init()
    --创建System
    for _,v in ipairs(_systemClass) do
        local class = require(v.classPath)
        local system = class.new()
        addSystem(system)
    end
    --对system进行轮询
    local scheduler = cc.Director:getInstance():getScheduler()
    _handle = scheduler:scheduleScriptFunc(update, 0, false)
end

function clear()
    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:unschedule(_handle)
   
    _clearEntities()
    _clearSystems()
   
    _handle = nil
    _entityCache = {}
    _systemCache = {}
    _eventQueue = {
        [EEventCacheType.Entity] = {},
        [EEventCacheType.System] = {}
    }
end

----
