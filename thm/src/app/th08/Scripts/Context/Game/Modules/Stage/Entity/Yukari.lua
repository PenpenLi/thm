module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("Yukari",StageDefine.PlayerEntity)

function M:ctor()
    M.super.ctor(self)

   
end

function M:__move()
     --细分状态:移动的各个状态是互斥的
     local inputComp = self:getComponent("InputComponent")
     if inputComp then
        local keyMapper = inputComp.keyMapper
        local moveStep = cc.p(0,0)
        if keyMapper:isKeyDown(EGameKeyType.MoveLeft) then
            moveStep.x = -Definition.Public.PLAYER_MOVE_STEP
        end
        if keyMapper:isKeyDown(EGameKeyType.MoveRight) then
            moveStep.x = Definition.Public.PLAYER_MOVE_STEP
        end
        if keyMapper:isKeyDown(EGameKeyType.MoveUp) then
            moveStep.y = Definition.Public.PLAYER_MOVE_STEP
        end
        if keyMapper:isKeyDown(EGameKeyType.MoveDown) then
            moveStep.y = -Definition.Public.PLAYER_MOVE_STEP
        end
        local oldX,oldY = self:getPosition()
        self:setPosition(cc.p(oldX+moveStep.x,oldY+moveStep.y))
    end
end

function M:__shot()
    
end

function M:__skill()
    
end

----------
function M:_onEnter()
    --初始化按键
    local inputComp = self:getComponent("InputComponent")
    if inputComp then
        local keyMapper = inputComp.keyMapper
        keyMapper:clear()

        keyMapper:registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
        keyMapper:registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
        keyMapper:registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
        keyMapper:registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
        keyMapper:registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
        keyMapper:registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
        keyMapper:registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
        keyMapper:registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)
    
        keyMapper:registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
        keyMapper:registerKey(ETouchType.OnceClick,EGameKeyType.Attack)
        keyMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)
    
        keyMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
        keyMapper:registerKey(ETouchType.Shake,EGameKeyType.Wipe)
        keyMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)
    
        keyMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Skill)
        keyMapper:registerKey(ETouchType.DoubleClick,EGameKeyType.Skill)
        keyMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Skill)
    
        keyMapper:registerKey(ETouchType.MultiTouch,EGameKeyType.Slow)
        keyMapper:registerKey(cc.KeyCode.KEY_SHIFT,EGameKeyType.Slow)

    end

    local animationComp = self:getComponent("AnimationComponent")
    local rigidbodyComp = self:getComponent("RigidbodyComponent")

    animationComp.sprite:setAnchorPoint(0.5,0.5)
    animationComp.sprite:setContentSize(cc.size(rigidbodyComp.body.width,rigidbodyComp.body.height))
    debugUI(animationComp.sprite)
end

function M:_onExit()
   
end

function M:_onUpdate()
    self:__move()
    self:__shot()
    -- self:__skill()
end

return M