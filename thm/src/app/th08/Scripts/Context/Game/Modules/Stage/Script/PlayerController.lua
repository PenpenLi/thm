local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",THSTG.ECS.Script)

function M:_onInit()
    self.roleType = nil                             --人物类型
    self.bulletEntity = false                       --子弹的实体
    self.shotInterval = 0.10                        --发射子弹的时间间隔
    self.initPos = cc.p(120,32)                     --玩家初始位置

end


----------
function M:move(x,y)
    local posComp = self:getComponent("TransformComponent")
    local offset = cc.p(x,y)

    posComp:setPositionX(posComp:getPositionX() + offset.x)
    posComp:setPositionY(posComp:getPositionY() + offset.y)
    
    ---动画模块
    local animationScript = self:getScript("PlayerAnimation")
    if offset.x < 0 then animationScript:play(StageDefine.ActionType.PLAYER_MOVE_LEFT)
    elseif offset.x > 0 then animationScript:play(StageDefine.ActionType.PLAYER_MOVE_RIGHT)
    else animationScript:play(StageDefine.ActionType.PLAYER_STAND) 
    end
end

function M:shot()
    --TODO:子弹应该复用
    --根据不同的人物,等级,发射的子弹可能不同
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        local bullet = self.bulletEntity.new()
        local myPosComp = self:getComponent("TransformComponent")
        local bulletPosComp = bullet:getComponent("TransformComponent")
        bulletPosComp:setPositionX(myPosComp:getPositionX() + 0)
        bulletPosComp:setPositionY(myPosComp:getPositionY() - 25)  --贴图尾巴太长了
        bullet:setAnchorPoint(cc.p(0.5,0.5))
        bullet:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)--TODO:一般是添加到一个空的实体上,但是应该怎么获取那个实体??

        self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
    end
end

function M:bomb()
   
end

function M:wipe(state)
    local function wipeOpen()
        print(15,"开")
    end
    local function wipeClose()
        print(15,"关")
    end
    --
    if self.__isStateWipe then
        if self.__isStateWipe ~= state then
            if state then 
                wipeOpen()
            else
                wipeClose()
            end
        end
    end
    self.__isStateWipe = state
end

function M:slow()

--根据不同人物显示不同的低速模式
end

------

function M:_onStart()
    self:__onInitMyself()
end

function M:_onUpdate()
    
end

function M:_onLateUpdate()

end

function M:_onEnd()
    
end
-------------
function M:__onInitMyself()
    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(self.initPos.x)
    myPosComp:setPositionY(self.initPos.y)

    self.roleType = Cache.roleCache.getType()
    self.bulletEntity = StageDefine.PlayerBullet    --TODO:根据roleType变换
end

return M