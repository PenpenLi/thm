local M = class("BossAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

---
function M:getBossType()
    return self.bossType
end

function M:_onStart()
    M.super._onStart(self)

    local bossControScript = self:getScript("BossController")
    self.bossType = bossControScript.bossType
end

---
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "MoveLeft",  from = {"Idle","MoveRight","Attack"},  to = "MoveLeft"},
            {name = "MoveRight",  from = {"Idle","MoveLeft","Attack"},  to = "MoveRight"},
            {name = "Attack",  from = {"Idle","MoveLeft","MoveRight"},  to = "Attack"},

            {name = "Idle", from = {"MoveRight","MoveLeft","Attack"},  to = "Idle"},
        },
        callbacks = {
            onAttack = handler(self,self._onAttack),
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
function M:_onAttack()
    self.spriteComp:setFlippedX(false)
    self.animaComp:stop()
    self.animaComp:playOnce({
        {AnimaState.ATTACK_START,nil,nil,1},
        {AnimaState.ATTACK_SUSBIN,nil,nil,5},   --循环5次
        {AnimaState.ATTACK_START,nil,nil,1,-1},
        {AnimaState.ATTACK_SUSBIN,nil,nil,1,-1},
    })
end

function M:_onMoveLeft(event)
    self.spriteComp:setFlippedX(false)
    self.animaComp:stop()
    self.animaComp:playOnce({
        {AnimaState.MOVE_LEFT_START,nil,nil,1},
        {AnimaState.MOVE_LEFT_SUSTAIN,nil,nil,-1},
    })
    
end

function M:_onMoveRight(event)
    self.spriteComp:setFlippedX(true)
    self.animaComp:stop()
    self.animaComp:playOnce({
        {AnimaState.MOVE_LEFT_START,nil,nil,1},
        {AnimaState.MOVE_LEFT_SUSTAIN,nil,nil,-1},
    })
end

function M:_onIdle(event)
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        self.animaComp:stop()
        self.animaComp:playOnce({
            {AnimaState.MOVE_LEFT_SUSTAIN,nil,nil,1,-1},
            {AnimaState.MOVE_LEFT_START,nil,nil,1,-1,function()
                self.spriteComp:setFlippedX(not self.spriteComp:isFlippedX())
            end},
            {AnimaState.IDLE,nil,nil,-1},
        })
    else
        self.animaComp:stop()
        self.animaComp:playForever(AnimaState.IDLE)
    end
end
---
return M