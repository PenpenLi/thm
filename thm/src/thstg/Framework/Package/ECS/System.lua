
--针对某一类组件进行轮询
local M = class("System")

function M.register(path)
    ECSManager.registerSystem(path)
end
---
function M:ctor(...)

    
    self:_onInit(...)
end

function M:update(delay)
    self:_onUpdate(delay)
end

--取得所有实体
function M:getAllEntities()
    return ECSManager.getAllEntities()
end
function M:getAllComponents()
    local ret = {}
    local entitys = self:getAllEntities()
    for _,v in pairs(entitys) do
        local comps = v:getAllComponents()
        for _,vv in pairs(comps) do
            table.insert( ret, vv )
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

return M