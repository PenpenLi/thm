local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    self.roleType = RoleType.REIMU                  --TODO:

    self.shotInterval = 0.10                        --发射子弹的时间间隔

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
    
    ---状态模块
    if dx < 0 then self.fsm:doEvent("Move")
    elseif dx > 0 then self.fsm:doEvent("Move")
    else self.fsm:doEvent("Idle")
    end
end

function M:shot()
    --TODO:子弹应该复用
    --根据不同的人物,等级,发射的子弹可能不同
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        local bullet = StageDefine.PlayerBullet.new()                   --TODO:受Slow,人物的影响,可能会变,主要以role决定
        local myPosComp = self:getComponent("TransformComponent")
        local bulletPosComp = bullet:getComponent("TransformComponent")
        bulletPosComp:setPositionX(myPosComp:getPositionX() + 0)
        bulletPosComp:setPositionY(myPosComp:getPositionY() - 25)  --贴图尾巴太长了
        bullet:setAnchorPoint(cc.p(0.5,0.5))
        bullet:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)--TODO:一般是添加到一个空的实体上,但是应该怎么获取那个实体??

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

function M:reset()
    --
    --1.关掉屏幕约束
    --2.从屏幕后方进入,并闪烁无敌时间
    --3.开始屏幕约束
    local constrainScript = self:getScript("ConstraintByBorder")
    constrainScript:setEnabled(false)

    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(display.cx)
    myPosComp:setPositionY(-100)

    local actionComp = self:getComponent("ActionComponent")
    actionComp:runAction(cc.Spawn:create({
        cc.Sequence:create({
            cc.MoveBy:create(1.0,cc.p(0,130)),
            cc.CallFunc:create(function()
                constrainScript:setEnabled(true)
            end)
        }),
        cc.Sequence:create({
            cc.Spawn:create({
                cc.CallFunc:create(function()
                    --TODO:处于无敌时间需要设置一个Flag
                end),
                cc.Blink:create(3.0, 200),
            }),
            
            cc.CallFunc:create(function()
                --无敌时间已过
                self:getEntity():setOpacity(255)
                self:getEntity():setVisible(true)
            end)
        })
    }))

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
------
function M:_onStart()
    M.super._onStart(self)

    self:reset()
end

function M:_onUpdate()
    
end

function M:_onLateUpdate()

end

function M:_onEnd()
    
end
-------------


return M