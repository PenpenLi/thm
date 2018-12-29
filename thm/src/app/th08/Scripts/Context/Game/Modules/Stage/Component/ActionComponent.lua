local M = class("ActionComponent",THSTG.ECS.Component)

function M:_onInit()
   
end
----
function M:runAction(action)
    self:getEntity():runAction(action)
end
----
function M:_onAdded(entity)
    local transComp = entity:getComponent("TransformComponent")
    assert(transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))    
end

function M:_onRemoved(entity)
    
end



return M