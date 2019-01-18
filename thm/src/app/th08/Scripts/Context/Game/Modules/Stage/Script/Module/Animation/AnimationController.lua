local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.fsm = THSTG.UTIL.newStateMachine() --状态机
    self.animaComp = nil

    self._prevPos = cc.p(0,0)
end
--
function M:play(actionType)
    if self.fsm:cannotDoEvent(actionType) then return end

    self.fsm:doEvent(actionType)
end
function M:getSprite()
    return self.animaComp:getSprite()
end
----
function M:_onLateUpdate()
    local posComp = self:getComponent("TransformComponent")
    local posPoint = cc.p(posComp:getPositionX(),posComp:getPositionY())
    
    self:_onAction({
        dx = posPoint.x - self._prevPos.x,
        dy = posPoint.y - self._prevPos.y,
    })

    self._prevPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
end

------------------
function M:_onStart()
    self.animaComp = self:getComponent("AnimationComponent")

    local cfg = self:_onState()
    if cfg and next(cfg) then
        self.fsm:setupState(cfg)
    end

    local posComp = self:getComponent("TransformComponent")
    self._prevPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
end
------------------
--[[以下由子类重载]]
function M:_onState()

end
--cc.Move无法主动调用,这里由自身进行判断
function M:_onMove(dx,dy)

end

function M:_onAction(params)
    self:_onMove(params.dx,params.dy)
end
--

return M