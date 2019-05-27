local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
--针对某一类组件进行轮询
local M = class("System")
---
local _entitiesAllList = false
function M.register(path)
    ECSManager.registerSystem(path)
end

function M._purge()
    _entitiesAllList = false
end
---
function M:ctor(...)
    self.__id__ = UIDUtil.getSystemUID()
    self.__groups__ = {}
    self.__groupsReady__ = {}
    self.__listenedClass__ = self:_getFilter()

    self:_onInit(...)
end

function M:getID()
    return self.__id__
end

function M:getClass()
    return self:_onClass( self.__cname )
end

--每帧更新
function M:update(delay)
    self:_onUpdate(delay)
end

function M:lateUpdate(delay)
    self:_onLateUpdate(delay)
end

--发送事件
function M:dispatch(e,params)
	ECSManager.dispatchEvent(ECSManager.EEventCacheType.System,e,params)
end

function M:clear()
    self:_onClear()
end

--取得所有实体
function M:getAllEntities()
    if not _entitiesAllList then
        _entitiesAllList = ECSManager.getAllEntities()
    end
    return _entitiesAllList
end

--查找包含某一组组件的组
function M:getGroups(args)
    --(实体过多会很卡)待优化,应该注册一种过滤器,监听组件变化
    local function oldCollectGroups(componentNames)
        if type(componentNames) ~= "table" then componentNames = {componentNames} end
        local retList = {}
        local entities = self:getAllEntities()
        for _,entity in pairs(entities) do
            local ret = {}
            local isOk = true
            for i = 1,#componentNames do
                local compName = componentNames[i]
                if type(compName) == "table" then compName = ECSUtil.trans2Name(unpack(compName)) end
                ret[compName] = entity:getComponent(compName)
                if not ret[compName] then 
                    isOk = false
                    break
                end
            end
            if isOk then
                ret._entity = entity
                table.insert(retList,ret)
            end
        end
        return retList
    end

    --新的实体收集
    local function newCollectGroups()
        local ret = self.__groups__
        return ret
    end

    if args == nil then
        return newCollectGroups()
    else
        return oldCollectGroups(args)
    end
    
end
---
--[[系统生命周期]]
function M:_onInit(...)
    
end

function M:_onAdded()
    if self.__listenedClass__ then
        ECSManager.getDispatcher():addEventListener(TYPES.ECSEVENT.ECS_ENTITY_COMPONENT_ADDED, self._collectGroup, self)
        ECSManager.getDispatcher():addEventListener(TYPES.ECSEVENT.ECS_ENTITY_COMPONENT_REMOVED, self._collectGroup, self)

        ECSManager.getDispatcher():addEventListener(TYPES.ECSEVENT.ECS_ENTITY_ADDED, self._handleGroups, self)
        ECSManager.getDispatcher():addEventListener(TYPES.ECSEVENT.ECS_ENTITY_REMOVED, self._handleGroups, self)

    end
end

function M:_onRemoved()
    if self.__listenedClass__ then
        ECSManager.getDispatcher():removeEventListener(TYPES.ECSEVENT.ECS_ENTITY_COMPONENT_ADDED, self._collectGroup, self)
        ECSManager.getDispatcher():removeEventListener(TYPES.ECSEVENT.ECS_ENTITY_COMPONENT_REMOVED, self._collectGroup, self)

        ECSManager.getDispatcher():removeEventListener(TYPES.ECSEVENT.ECS_ENTITY_ADDED, self._handleGroups, self)
        ECSManager.getDispatcher():removeEventListener(TYPES.ECSEVENT.ECS_ENTITY_REMOVED, self._handleGroups, self)
    end
end

--[[以下需要被重载]]
function M:_onUpdate(delay)
    --通过对Entity获取到相应的Component
end

function M:_onLateUpdate(delay)

end

function M:_onFilter()
    return false
end

function M:_onClear()

end

function M:_onClass(className)
    return {className}
end

---
function M:_getFilter()
    local list = self:_onFilter()
    if list then
        local map = {}
        for _,v in ipairs(list) do
            local name = v
            if type(name) == "table" then name = ECSUtil.trans2Name(unpack(name)) end
            map[name] = name
        end
        return map
    end
    return false
end

--TODO:在ColliderSystem使用有问题
function M:_collectGroup(e,comp)
    local function isListenerClass(className,classArgs)
        if not self.__listenedClass__[className] then
            for _,v in pairs(self.__listenedClass__) do
                if ECSUtil.isKindof(classArgs,v) then
                    return true
                end
            end
            return false
        else
            return true
        end
        return false
    end

    local entity = comp:getEntity()
    local className,classArgs = comp:getClass()
    local entityId = entity:getID()
    
    if isListenerClass(className,classArgs) then
        if e == ECSEVENT.ECS_ENTITY_COMPONENT_ADDED then
            --是否已经有了,没有就要添加
            if not self.__groupsReady__[entityId] then
                local ret = {}
                local isOk = true
                for _,name in pairs(self.__listenedClass__) do
                    ret[name] = entity:getComponent(name)
                    if not ret[name] then 
                        isOk = false
                        break
                    end
                end
                if isOk then
                    --包括那些没进入场景的,在池中的实体
                    ret._entity = entity
                    self.__groupsReady__[entityId] = ret
                end
            end
        elseif e == ECSEVENT.ECS_ENTITY_COMPONENT_REMOVED then
            --是否已经有了,有了就要移除
            if self.__groupsReady__[entityId] then
                self.__groupsReady__[entityId] = nil
            end
            if self.__groups__[entityId] then
                self.__groups__[entityId] = nil
            end
        end
    end
end

function M:_handleGroups(e,entity)
    local entityId = entity:getID()
    if e == TYPES.ECSEVENT.ECS_ENTITY_ADDED then --从预备组转到可用组
        if not self.__groups__[entityId] then
            self.__groups__[entityId] = self.__groupsReady__[entityId]
        end
    
    elseif e == TYPES.ECSEVENT.ECS_ENTITY_REMOVED then --从可用组转到预备组
        if self.__groups__[entityId] then
            self.__groups__[entityId] = nil
        end
    end
end

return M