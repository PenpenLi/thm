local M = class("BatmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)

end
--

---
function M:_onStart()
    M.super._onStart(self)

end

---
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "MoveLeft",  from = {"Idle","MoveRight"},  to = "MoveLeft"},
            {name = "MoveRight",  from = {"Idle","MoveLeft"},  to = "MoveRight"},

            {name = "Idle", from = {"MoveRight","MoveLeft"},  to = "Idle"},
        },
        callbacks = {
            onMoveLeft = handler(self,self._onMoveLeft),
            onMoveRight = handler(self,self._onMoveRight),
            onIdle = handler(self,self._onIdle),
        },
    }
end
---
function M:_onMove(dx,dy)
    --主要根据移动方式判断动画
    if dx > 0 then
        self:play("MoveLeft")
    elseif dx < 0 then
        self:play("MoveRight")
    else
        self:play("Idle")
    end
end

----
function M:_onMoveLeft(event)
    self.spriteComp:setFlippedX(true)
    self.animaComp:stop()
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        self.animaComp:playOnce({
            {AnimaState.MOVE_RIGHT_TURN,nil,nil,1},
            {AnimaState.MOVE_RIGHT_SUSTAIN,nil,nil,-1},
        })
    else
        self.animaComp:playForever(AnimaState.MOVE_RIGHT_SUSTAIN)
    end
end

function M:_onMoveRight(event)
    self.spriteComp:setFlippedX(false)
    self.animaComp:stop()
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        self.animaComp:playOnce({
            {AnimaState.MOVE_RIGHT_TURN,nil,nil,1},
            {AnimaState.MOVE_RIGHT_SUSTAIN,nil,nil,-1},
        })
    else
        self.animaComp:playForever(AnimaState.MOVE_RIGHT_SUSTAIN)
    end
end

function M:_onIdle(event)
    self.animaComp:stop()
    self.animaComp:playForever(AnimaState.IDLE)
end

--
return M