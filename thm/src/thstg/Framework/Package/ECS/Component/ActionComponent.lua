local M = class("ActionComponent",ECS.Component)

function M:_onInit()
    self._action = false
end

function M:runOnce(action)
    if action then
        self:stop()
        self:getEntity():runAction(action)
        self._action = action 
    end
end

function M:runSequence(actions)
    if actions then
        self:stop()
        local action = cc.Sequence:create(actions)
        self:getEntity():runAction(action)
        self._action = action 
    end
end

function M:runForever(actions)
    if actions then
        self:stop()
        local action = cc.RepeatForever:create(actions)
        self:getEntity():runAction(action)
        self._action = action 
    end
end


function M:stop()
    self:getEntity():stopAllActions()
    self._action = false

    -- if self._action then
    --     if not tolua.isnull(self._action) then
    --         self:getEntity():stopAction(self._action)
    --         self._action = false
    --     end
    -- end
end

----
function M:_onAdded(entity)
    local transComp = entity:getComponent("TransformComponent")
    assert(transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))    
end

function M:_onRemoved(entity)
    
end




return M