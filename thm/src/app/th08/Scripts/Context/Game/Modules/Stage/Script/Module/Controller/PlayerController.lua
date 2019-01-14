local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.shotInterval = 0.10                        --发射子弹的时间间隔
    self.initPos = cc.p(120,32)                     --玩家初始位置

    self.__isStateWipe = false                         --擦弹模式
    self.__isStateSlow = false                         --低速模式
end


----------
function M:move(dx,dy)
    if self:isSlow() then
        --低速模式速度减半
        dx = dx / 2 
        dy = dy / 2
    end
    M.super.move(self,dx,dy)
    
    ---动画模块
    local animationScript = self:getScript("PlayerAnimation")
    if dx < 0 then 
        animationScript:play("MoveLeft")
        self.fsm:doEvent("Move")
    elseif dx > 0 then 
        animationScript:play("MoveRight")
        self.fsm:doEvent("Move")
    else 
        animationScript:play("Idle") 
        self.fsm:doEvent("Idle")
    end
end

function M:shot()
    --TODO:子弹应该复用
    --根据不同的人物,等级,发射的子弹可能不同
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        local bullet = StageDefine.PlayerBullet.new()
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
    print(15,"炸弹")
end

function M:wipe(state)
    local function wipeOpen()
        print(15,"wipe开")
    end
    local function wipeClose()
        print(15,"wipe关")
    end
    --
    if state then wipeOpen() else wipeClose() end
    self.__isStateWipe = state
end

function M:slow(state)
    local function slowOpen()
        print(15,"slow开")
    end
    local function slowClose()
        print(15,"slow关")
    end
    --根据不同人物显示不同的低速模式
    if state then slowOpen() else slowClose() end
    self.__isStateSlow = state
end

function M:isWipe()
    return self.__isStateWipe or false
end
function M:isSlow()
    return self.__isStateSlow or false
end
------
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "Move",  from = {"Idle","Move"},  to = "Move"},
            {name = "Idle", from = "*",  to = "Idle"},
        },
        callbacks = {
        },
    }
end

------
function M:_onStart()
    M.super._onStart(self)

    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(self.initPos.x)
    myPosComp:setPositionY(self.initPos.y)
 
end

function M:_onUpdate()
    
end

function M:_onLateUpdate()

end

function M:_onEnd()
    
end
-------------


return M