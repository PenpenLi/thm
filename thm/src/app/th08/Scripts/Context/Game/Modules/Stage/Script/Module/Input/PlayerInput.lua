local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("PlayerInput",StageDefine.InputController)

function M:_onInit()
    M.super._onInit(self)



end

--
function M:_onRegister(keyMapper)
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

    keyMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Bomb)
    keyMapper:registerKey(ETouchType.DoubleClick,EGameKeyType.Bomb)
    keyMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Bomb)

    keyMapper:registerKey(ETouchType.MultiTouch,EGameKeyType.Slow)
    keyMapper:registerKey(cc.KeyCode.KEY_SHIFT,EGameKeyType.Slow)
end

function M:_onHandle(inputComp)
    self:__onMove(inputComp)
    self:__onShot(inputComp)
    self:__onBomb(inputComp)
    self:__onWipe(inputComp)
    self:__onSlow(inputComp)
end
------------------
------------------
function M:__onMove(inputComp)
    local function keyMove(inputComp,posComp)
        local moveStep = cc.p(0,0)
        if inputComp:isKeyDown(EGameKeyType.MoveLeft) then
            moveStep.x = -Definition.Public.PLAYER_KEY_MOVE_STEP
        elseif inputComp:isKeyDown(EGameKeyType.MoveRight) then
            moveStep.x = Definition.Public.PLAYER_KEY_MOVE_STEP
        end
        if inputComp:isKeyDown(EGameKeyType.MoveUp) then
            moveStep.y = Definition.Public.PLAYER_KEY_MOVE_STEP
        elseif inputComp:isKeyDown(EGameKeyType.MoveDown) then
            moveStep.y = -Definition.Public.PLAYER_KEY_MOVE_STEP
        end
    
        return moveStep
    
    end
    
    local function touchMove(inputComp,posComp)
        local destPos = inputComp:getTouchPos()
        if destPos then
            local moveStep = cc.p(0,0)
            local curPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
            local destPos = cc.p(destPos.x,destPos.y)
            local shift = cc.pSub(destPos, curPos) 
            local length = cc.pGetLength(shift)
            if length <= Definition.Public.PLAYER_TOUCH_MOVE_STEP then
                moveStep.x = destPos.x - posComp:getPositionX()
                moveStep.y = destPos.y - posComp:getPositionY()
            else
                local angle = cc.pGetAngle(cc.p(1,0),shift)
                moveStep.x = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.cos(angle)
                moveStep.y = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.sin(angle)
            end
            return moveStep
        end
    
        return false
    end
    --------

    --移动这里是互斥的
    local posComp = self:getComponent("TransformComponent")
    local offset = touchMove(inputComp,posComp) or keyMove(inputComp,posComp) or cc.p(0,0)

    local playControllerScript = self:getScript("PlayerController")
    playControllerScript:move(offset.x,offset.y)
end

function M:__onShot(inputComp)
    if inputComp:isKeyDown(EGameKeyType.Attack) then
        local playControllerScript = self:getScript("PlayerController")
        playControllerScript:shot()
    end
   
end

function M:__onBomb(inputComp)
    if inputComp:isKeyDown(EGameKeyType.Bomb) then
        
        local playControllerScript = self:getScript("PlayerController")
        playControllerScript:bomb()
        inputComp:resetKey(EGameKeyType.Bomb)
    end
end

function M:__onWipe(inputComp)
    local playControllerScript = self:getScript("PlayerController")
    playControllerScript:wipe(inputComp:isKeyDown(EGameKeyType.Wipe))
end

function M:__onSlow(inputComp)
    if inputComp:isKeyDown(EGameKeyType.Slow) then

       local playControllerScript = self:getScript("PlayerController")
       playControllerScript:slow()
       inputComp:resetKey(EGameKeyType.Slow)
    end
end


return M