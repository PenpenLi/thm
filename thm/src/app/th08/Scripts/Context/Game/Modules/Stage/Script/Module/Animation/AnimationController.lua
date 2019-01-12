local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.fsm = THSTG.UTIL.newStateMachine() --状态机
    self.sprite = nil
end
--
function M:play(actionType)
    if self.fsm:cannotDoEvent(actionType) then return end

    self.fsm:doEvent(actionType)
end
----
function M:_onLateUpdate()
    --根据实体状态判断需要执行的动画
end

------------------
function M:_onStart()
    self.sprite = self:getComponent("SpriteComponent"):getSprite()

    local cfg = self:_onState()
    self.fsm:setupState(cfg)
end
------------------
--[[以下由子类重载]]
function M:_onState()

end
--

return M