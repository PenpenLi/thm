local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.fsm = THSTG.UTIL.newStateMachine() --状态机
    self.sprite = nil
end
--
function M:play(actionType)
    if self.fsm:getState() == actionType then return end
    
    self.fsm:doEvent(actionType)
end


------------------
function M:_onStart()
    self.sprite = self:getComponent("SpriteComponent"):getSprite()

    local cfg = self:_onSetup()
    self.fsm:setupState(cfg)
end
------------------
--[[以下由子类重载]]
function M:_onSetup()

end
--

return M