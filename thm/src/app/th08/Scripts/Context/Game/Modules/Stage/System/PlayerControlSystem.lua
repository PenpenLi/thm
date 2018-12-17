local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerControlSystem",THSTG.ECS.System)

-------------
--[[控制模块]]

function M:__onKeyMove(keyMapper)
    --细分状态:移动的各个状态是互斥的
    local moveStep = cc.p(0,0)
    if keyMapper:isKeyDown(EGameKeyType.MoveLeft) then
        moveStep.x = -Definition.Public.PLAYER_KEY_MOVE_STEP
    end
    if keyMapper:isKeyDown(EGameKeyType.MoveRight) then
        moveStep.x = Definition.Public.PLAYER_KEY_MOVE_STEP
    end
    if keyMapper:isKeyDown(EGameKeyType.MoveUp) then
        moveStep.y = Definition.Public.PLAYER_KEY_MOVE_STEP
    end
    if keyMapper:isKeyDown(EGameKeyType.MoveDown) then
        moveStep.y = -Definition.Public.PLAYER_KEY_MOVE_STEP
    end

    local posComp = self:getComponent("PositionComponent")
    posComp.x = posComp.x + moveStep.x
    posComp.y = posComp.y + moveStep.y
  
end

function M:__onTouchMove(touchPos)
    local destPos = touchPos

    if destPos then
        local posComp = self:getComponent("PositionComponent")
        local curPos = cc.p(posComp.x,posComp.y)

        local destPos = cc.p(destPos.x,destPos.y)
        local shift = cc.pSub(destPos, curPos) 
        local length = cc.pGetLength(shift)
        if length <= Definition.Public.PLAYER_TOUCH_MOVE_STEP then
            posComp.x = destPos.x
            posComp.y = destPos.y
        else
            local angle = cc.pGetAngle(cc.p(1,0),shift)
            local offesetX = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.cos(angle)
            local offesetY = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.sin(angle)
            posComp.x = (posComp.x + offesetX)
            posComp.y = (posComp.y + offesetY)
        end
    end
end

function M:__onShot(keyMapper)
    if keyMapper:isKeyDown(EGameKeyType.Attack) then
        
    end
end

function M:__onSkill(keyMapper)
    if keyMapper:isKeyDown(EGameKeyType.Skill) then
       
    end
end

function M:__onSlow(keyMapper)
    if keyMapper:isKeyDown(EGameKeyType.Skill) then
       
    end
end

function M:__onInputInit()
    --初始化按键
    local inputComp = self:getComponent("InputComponent")
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

function M:__onInputHandle()
    local inputComp = self:getComponent("InputComponent")
    local keyMapper = inputComp.keyMapper
    local touchPos = inputComp.touchPos
    self:__onKeyMove(keyMapper)
    self:__onTouchMove(touchPos)
    self:__onShot(keyMapper)
    self:__onSkill(keyMapper)
    self:__onSlow(keyMapper)
end

------
function M:_onAdded()

    self:__onInputInit()
end


function M:_onUpdate()
    self:__onInputHandle()
end


return M