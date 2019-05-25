local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
--针对某一类组件进行轮询
local M = class("System")

---
local _entitiesAllList = false
local _entitiesAllComponents = false
local _entitiesComponents = {}
function M.register(path)
    ECSManager.registerSystem(path)
end

function M._purge()
    _entitiesAllList = false
    _entitiesAllComponents = false
    _entitiesComponents = {}
end
---
function M:ctor(...)
    self.__id__ = UIDUtil.getSystemUID()

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
--TODO:(实体过多会很卡)待优化,应该注册一种过滤器,监听组件变化
function M:getCompsGroups(componentNames)
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

--TODO:
function M:getGroups(groupClass)
    
end
---
--[[系统生命周期]]
function M:_onInit(...)
    
end

--[[以下需要被重载]]
function M:_onUpdate(delay)
    --通过对Entity获取到相应的Component
end

function M:_onLateUpdate(delay)

end

function M:_onEvent(event,params)

end

function M:_onClear()

end

--

function M:_onClass(className)
    return className
end
return M