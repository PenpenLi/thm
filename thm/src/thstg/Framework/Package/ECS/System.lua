
--针对某一类组件进行轮询
local M = class("System")

function M.register(path)
    ECSManager.registerSystem(path)
end
---
function M:ctor(...)

    
    self:_onInit(...)
end

function M:getClass()
    return self:_onClass( self.__cname )
end

function M:update(delay)
    self:_onUpdate(delay)
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
    return ECSManager.getAllEntities()
end
function M:getAllComponents()
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
    return ret
end
--取得所有某类组件
function M:getComponents(name)
    local ret = {}
    local entitys = self:getAllEntities()
    for _,v in pairs(entitys) do
        local comp = v:getComponent(name)
        if comp then
            table.insert(ret, comp)
        end
    end
    return ret
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