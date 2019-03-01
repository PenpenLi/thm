local EGameKeyType = Const.Public.EGameKeyType
local ETouchExType = THSTG.CONST.PUBLIC.ETouchExType
local M = class("PlayerInput",StageDefine.InputController)

function M:_onInit()
    M.super._onInit(self)


    self.inputCache = {}
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
    keyMapper:registerKey(ETouchExType.OnceClick,EGameKeyType.Attack)
    keyMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)

    keyMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
    keyMapper:registerKey(ETouchExType.Shake,EGameKeyType.Wipe)
    keyMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)

    keyMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Bomb)
    keyMapper:registerKey(ETouchExType.DoubleClick,EGameKeyType.Bomb)
    keyMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Bomb)

    keyMapper:registerKey(ETouchExType.MultiTouch,EGameKeyType.Slow)
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
            moveStep.x = -Const.Stage.PLAYER_KEY_MOVE_STEP
        elseif inputComp:isKeyDown(EGameKeyType.MoveRight) then
            moveStep.x = Const.Stage.PLAYER_KEY_MOVE_STEP
        end
        if inputComp:isKeyDown(EGameKeyType.MoveUp) then
            moveStep.y = Const.Stage.PLAYER_KEY_MOVE_STEP
        elseif inputComp:isKeyDown(EGameKeyType.MoveDown) then
            moveStep.y = -Const.Stage.PLAYER_KEY_MOVE_STEP
        end

        return moveStep
    end
    
    local function touchMove(inputComp,posComp)
        local touchPos = inputComp:getTouchPos()
        -- if (touchPos or self.destPos) then
        if (touchPos) then
            if touchPos then self.destPos = cc.p(touchPos.x,touchPos.y) end
            local moveStep = cc.p(0,0)
            local curPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
            local shift = cc.pSub(self.destPos, curPos) 
            local length = cc.pGetLength(shift)
            if length <= Const.Stage.PLAYER_TOUCH_MOVE_STEP then
                moveStep.x = self.destPos.x - posComp:getPositionX()
                moveStep.y = self.destPos.y - posComp:getPositionY()
                self.destPos = nil
            else
                local angle = cc.pGetAngle(cc.p(1,0),shift)
                moveStep.x = Const.Stage.PLAYER_TOUCH_MOVE_STEP * math.cos(angle)
                moveStep.y = Const.Stage.PLAYER_TOUCH_MOVE_STEP * math.sin(angle)
            end
            return moveStep
        end
    
        return false
    end
    --------

    --移动这里是互斥的
    local posComp = self:getComponent("TransformComponent")
    local offset = touchMove(inputComp,posComp) or keyMove(inputComp,posComp) or cc.p(0,0)
    local playerControllerScript = self:getScript("PlayerController")
    playerControllerScript:move(offset.x,offset.y)
end

function M:__onShot(inputComp)
    if inputComp:isKeyDown(EGameKeyType.Attack) then
        local playerControllerScript = self:getScript("PlayerController")
        playerControllerScript:shot()
    end
   
end

function M:__onBomb(inputComp)
    if inputComp:isKeyDown(EGameKeyType.Bomb) then
        local playerControllerScript = self:getScript("PlayerController")
        playerControllerScript:bomb()
        inputComp:resetKey(EGameKeyType.Bomb)
    end
end

function M:__onWipe(inputComp)
    local playerControllerScript = self:getScript("PlayerController")
    local state = inputComp:isKeyDown(EGameKeyType.Wipe)
    if self.inputCache[EGameKeyType.Wipe] ~= nil then
        if self.inputCache[EGameKeyType.Wipe] ~= state then
            playerControllerScript:wipe(state)
        end
    end
    self.inputCache[EGameKeyType.Wipe] = state
end

function M:__onSlow(inputComp)
    local playerControllerScript = self:getScript("PlayerController")
    local state = inputComp:isKeyDown(EGameKeyType.Slow)
    if self.inputCache[EGameKeyType.Slow] ~= nil then
        if self.inputCache[EGameKeyType.Slow] ~= state then
            playerControllerScript:slow(state)
        end
    end
    self.inputCache[EGameKeyType.Slow] = state
end


return M