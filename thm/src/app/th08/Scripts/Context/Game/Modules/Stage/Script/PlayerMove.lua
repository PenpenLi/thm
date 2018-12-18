local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local ANIMATE_PATH = "Scripts.Context.Game.Modules.Stage.Config.Animation.%s"
local M = class("PlayerMove",THSTG.ECS.Script)

function M:_onInit()
    --消息
end
-------------
--[[控制模块]]

function M:__onKeyMove(inputComp,posComp)
    --细分状态:移动的各个状态是互斥的
    local moveStep = cc.p(0,0)
    local keyMapper = inputComp.keyMapper
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

    return moveStep

end

function M:__onTouchMove(inputComp,posComp)
    local destPos = inputComp.touchPos
    if destPos then
        local moveStep = cc.p(0,0)
        local curPos = cc.p(posComp.x,posComp.y)
        local destPos = cc.p(destPos.x,destPos.y)
        local shift = cc.pSub(destPos, curPos) 
        local length = cc.pGetLength(shift)
        if length <= Definition.Public.PLAYER_TOUCH_MOVE_STEP then
            moveStep.x = destPos.x - posComp.x
            moveStep.y = destPos.y - posComp.y
        else
            local angle = cc.pGetAngle(cc.p(1,0),shift)
            moveStep.x = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.cos(angle)
            moveStep.y = Definition.Public.PLAYER_TOUCH_MOVE_STEP * math.sin(angle)
        end
        return moveStep
    end

    return false
end

function M:__onMove(inputComp)
    --移动这里是互斥的
    local posComp = self:getComponent("PositionComponent")
    local offset = self:__onTouchMove(inputComp,posComp) or self:__onKeyMove(inputComp,posComp) or cc.p(0,0)

    posComp.x = posComp.x + offset.x
    posComp.y = posComp.y + offset.y

    if offset.x < 0 then self.curAnimation = StageDefine.ActionType.PLAYER_MOVE_LEFT
    elseif offset.x > 0 then self.curAnimation = StageDefine.ActionType.PLAYER_MOVE_RIGHT
    else
        self.curAnimation = StageDefine.ActionType.PLAYER_STAND
    end


end

function M:__onKill(inputComp)
    local keyMapper = inputComp.keyMapper
    if keyMapper:isKeyDown(EGameKeyType.Attack) then
        
    end
    if keyMapper:isKeyDown(EGameKeyType.Skill) then
       
    end
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
    self:__onMove(inputComp)
    self:__onKill(inputComp)
end
--------------
--[[动画模块]]
function M:__onAnimationInit(params)
    self.roleType = nil                 --人物类型
    self.curAnimation = nil             --当前动作
    self._lastAnimation = nil           --动作

    self._animationDict = false
end

function M:__playAnime(action)
    if action == self._lastAnimation then return end
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite

    local function getAnime(action)
        if not self._animationDict then
            local path = string.format(ANIMATE_PATH,self.roleType)
            self._animationDict = require(path)
        end
        return self._animationDict[action]
    end

    --查找配置
    local actionFunc = getAnime(action)
    actionFunc(sprite,self._lastAnimation)

    self._lastAnimation = action
end

function M:__onAnimationHandle()
    if self.curAnimation then
        self:__playAnime(self.curAnimation)
    end
end

------
function M:_onStart(params)

    self:__onInputInit(params)
    self:__onAnimationInit(params)
end


function M:_onUpdate()
    self:__onInputHandle()
    
end

function M:_onLateUpdate()
    self:__onAnimationHandle()
end


return M