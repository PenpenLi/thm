local M = class("ActionComponent",ECS.Component)

function M:_onInit()
   
end
----
function M:runAction(action)
    self:getEntity():runAction(action)
end

function M:runSeqAct(actions)
    local action = cc.Sequence:create(actions)
    self:runAction(action)
end

function M:runForeAct(action)
    local action = cc.RepeatForever:create(action)
    self:runAction(action)
end

function M:stopAllActions()
    self:getEntity():stopAllActions()
end
----
function M:_onAdded(entity)
    local transComp = entity:getComponent("TransformComponent")
    assert(transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))    
end

function M:_onRemoved(entity)
    
end

function M:_onActive(val)
    if val == false then
        self:stopAllActions()
    end
end



return M