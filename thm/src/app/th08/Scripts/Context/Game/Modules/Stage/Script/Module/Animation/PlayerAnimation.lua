local M = class("PlayerAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
    
end

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

----
function M:_onStart()
    M.super._onStart(self)

    
end

function M:_onSetup()
    --重定向组件
    self.animaComp = self:getEntity():findChild("SPRITE_NODE"):getComponent("AnimationComponent")
    self.spriteComp = self:getEntity():findChild("SPRITE_NODE"):getComponent("SpriteComponent")
    
    M.super._onSetup(self)
end
----
function M:_onMove(dx,dy)
    if dx < 0 then 
        self:play("MoveLeft")
    elseif dx > 0 then 
        self:play("MoveRight")
    else 
        self:play("Idle") 
    end
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
    self.animaComp:stop()
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        self.animaComp:playOnce({
            {AnimaState.MOVE_LEFT_SUSTAIN,nil,nil,1,-1},
            {AnimaState.MOVE_LEFT_START,nil,nil,1,-1,function()
                self.spriteComp:setFlippedX(not self.spriteComp:isFlippedX())
            end},
            {AnimaState.IDLE,nil,nil,-1},
        })
    else
        self.animaComp:playForever(AnimaState.IDLE)
    end
end

----


return M