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
    self.__id__ = ECSUtil.getSystemId()

    self:_onInit(...)
end

function M:getID()
    return self.__id__
end

function M:getClass()
    return self:_onClass( self.__cname )
end

--应该使用脏队列
function M:update(delay)
    ---

    self:_onUpdate(delay)
    self:_onLateUpdate(delay)

    ---

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

function M:getAllComponents()
    if not _entitiesAllComponents then
        local ret = {}
        local entitys = self:getAllEntities()
        for _,v in pairs(entitys) do
            if v:isActive() then
                local comps = v:getAllComponents()
                for _,vv in pairs(comps) do
                    table.insert( ret, vv )
                end
            end
        end
        _entitiesAllComponents = ret
    end
    return _entitiesAllComponents
end

--取得所有某类组件
function M:getComponents(name)
    if not _entitiesComponents[name] then
        local ret = {}
        local entitys = self:getAllEntities()
        for _,v in pairs(entitys) do
            if v:isActive() then
                local comp = v:getComponent(name)
                if comp then
                    table.insert(ret, comp)
                end
            end
        end
        _entitiesComponents[name] = ret
    end
    return _entitiesComponents[name]
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
    --通过对Entity获取到相应的Component
end

function M:_onEvent(event,params)

end

function M:_onClear()

end

function M:_onClass(className)
    return className
end
return M