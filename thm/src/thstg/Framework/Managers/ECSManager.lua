module("ECSManager", package.seeall)
--
local _handle = nil
local _entityCache = {}

local _systemClass = {}
local _systemCache = {}
---
--[[实体管理]]
function addEntity(entity)
    _entityCache[entity] = entity
end

function removeEntity(entity)
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

function findEntitysWithTag(tag)
	local list = {}
	visitEntity(function(entity)
		if entity:getTag() == tag then
			table.insert( list, entity )
		end
	end)
	return list
end

function findEntityWithTag(tag)
	return findEntitysWithTag(tag)[1]
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


----

function update(delay)
    visitSystem(function(v)
        v:update(delay)
    end)
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

    visitEntity(function(v)
        v:clear()
    end)

    visitSystem(function(v)
        v:clear()
    end)


    _handle = nil
    _entityCache = {}
    _systemCache = {}

end