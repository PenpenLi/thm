local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",THSTG.ECS.Script)

function M:_onInit()
    self.roleType = nil                             --人物类型
    self.bulletEntity = false                       --子弹的实体
    self.shotInterval = 0.05                        --发射子弹的时间间隔
    self.life = 3                                   --残机数
    self.initPos = cc.p(120,32)                     --玩家初始位置

    self._nextShotTime = 0
end
-------------
function M:__onInitMyself()
    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(self.initPos.x)
    myPosComp:setPositionY(self.initPos.y)

    self.roleType = Cache.roleCache.getType()
    self.bulletEntity = StageDefine.PlayerBullet    --TODO:根据roleType变换
end
-------------
--[[控制模块]]

function M:__onKeyMove(inputComp,posComp)
    local moveStep = cc.p(0,0)
    local keyMapper = inputComp.keyMapper
    if keyMapper:isKeyDown(EGameKeyType.MoveLeft) then
        moveStep.x = -Definition.Public.PLAYER_KEY_MOVE_STEP
    elseif keyMapper:isKeyDown(EGameKeyType.MoveRight) then
        moveStep.x = Definition.Public.PLAYER_KEY_MOVE_STEP
    end
    if keyMapper:isKeyDown(EGameKeyType.MoveUp) then
        moveStep.y = Definition.Public.PLAYER_KEY_MOVE_STEP
    elseif keyMapper:isKeyDown(EGameKeyType.MoveDown) then
        moveStep.y = -Definition.Public.PLAYER_KEY_MOVE_STEP
    end

    return moveStep

end

function M:__onTouchMove(inputComp,posComp)
    local destPos = inputComp.touchPos
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

function M:__onMove(inputComp)

    --移动这里是互斥的
    local posComp = self:getComponent("TransformComponent")
    local offset = self:__onTouchMove(inputComp,posComp) or self:__onKeyMove(inputComp,posComp) or cc.p(0,0)

    --TODO:边界检测
    posComp:setPositionX(posComp:getPositionX() + offset.x)
    posComp:setPositionY(posComp:getPositionY() + offset.y)


    if offset.x < 0 then self._curAnimation = StageDefine.ActionType.PLAYER_MOVE_LEFT
    elseif offset.x > 0 then self._curAnimation = StageDefine.ActionType.PLAYER_MOVE_RIGHT
    else self._curAnimation = StageDefine.ActionType.PLAYER_STAND
    end
end

function M:__onKill(inputComp)
    local keyMapper = inputComp.keyMapper
    if keyMapper:isKeyDown(EGameKeyType.Attack) then
        --根据不同的人物,等级,发射的子弹可能不同
        if THSTG.TimeUtil.time() >= self._nextShotTime then
            local bullet = self.bulletEntity.new()
            local myPosComp = self:getComponent("TransformComponent")
            local bulletPosComp = bullet:getComponent("TransformComponent")
            bulletPosComp:setPositionX(myPosComp:getPositionX() + 0)
            bulletPosComp:setPositionY(myPosComp:getPositionY() - 25)  --贴图尾巴太长了
            bullet:setAnchorPoint(cc.p(0.5,0.5))
            bullet:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)

            self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
        end
    end
    if keyMapper:isKeyDown(EGameKeyType.Skill) then
       --这里又要实时变化模式-
    end
    if keyMapper:isKeyDown(EGameKeyType.Slow) then
       --这里又要实时变化子弹模式-
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
    
    self._curAnimation = nil            --当前动作
    self._lastAnimation = nil           --动作

    self._animationDict = false
end

function M:__playAnime(action)
    if action == self._lastAnimation then return end
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite

    --查找配置
    local actionFunc = StageDefine.ConfigReader.getAnime(self.roleType,action)
    actionFunc(sprite,self._lastAnimation)

    self._lastAnimation = action
end

function M:__onAnimationHandle()
    if self._curAnimation then
        self:__playAnime(self._curAnimation)
    end
end

----
--[[碰撞检测]]
function M:__onCollisionHandle()
    local system = self:getSystem("CollisionSystem")
    if system then
        if system:isCollided(self:getEntity(),{"PLAYER_BULLET"}) then
            print(15,"collide") 
        end
    end
end

------
function M:_onAdded(params)
    self:__onInputInit(params)
    self:__onAnimationInit(params)
end

function M:_onStart()
    self:__onInitMyself()
end

function M:_onUpdate()
    self:__onInputHandle()
end

function M:_onLateUpdate()
    self:__onAnimationHandle()
    self:__onCollisionHandle()
end

function M:_onEnd()
    
end

return M