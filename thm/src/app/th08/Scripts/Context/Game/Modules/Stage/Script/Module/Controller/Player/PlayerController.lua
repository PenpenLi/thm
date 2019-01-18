local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    self.roleType = RoleType.REIMU                  --TODO:

    self.shotInterval = 0.10                        --发射子弹的时间间隔
    self.bombCount = 3                              --Bomb次数
    self.wipeRestTime = 5                           --wipe的剩余时间

    ObjectCache.expand(StageDefine.PlayerBullet,6)        --最大5颗,与子弹速度有关

end


----------
function M:move(dx,dy)
    if self.__isLockMove then return end --重设阶段不能移动
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
        --TODO:受Slow,人物的影响,可能会变,主要以role决定
        local bullet = ObjectCache.create(StageDefine.PlayerBullet)
        local bulletControlScript = bullet:getScript("PlayerBulletController")
        bulletControlScript:reset(self:getEntity())
        bullet:setActive(true)

        self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
    end
end

function M:bomb()
    if self.bombCount <= 0 then return end
    print(15,"炸弹")
    THSTG.Dispatcher.dispatchEvent(EventType.STAGE_SPELLCARD_EFFECT_WND,{isPlayer = true,isOpen = true})

    self.bombCount = self.bombCount - 1
    --TODO:决死效果
end

function M:getBombCount()
    return self.bombCount
end

function M:setBombCount(val)
    self.bombCount = val
end

function M:wipe(state)
    --擦弹模式开始定时器,超时自动关闭
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
    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(display.cx)
    myPosComp:setPositionY(-100)

    local constrainScript = self:getScript("ConstraintByBorder")
    local myHealthComp = self:getScript("PlayerHealth")

    local actionComp = self:getComponent("ActionComponent")
    actionComp:runAction(cc.Spawn:create({
        cc.Sequence:create({
            cc.CallFunc:create(function()
                constrainScript:setEnabled(false)
                self.__isLockMove = true
            end),
            cc.MoveBy:create(1.0,cc.p(0,130)),
            cc.CallFunc:create(function()
                constrainScript:setEnabled(true)
                self.__isLockMove = false
            end)
        }),
        cc.Sequence:create({
            cc.Spawn:create({
                cc.CallFunc:create(function()
                    myHealthComp:setInvincible(true)
                end),
                cc.Blink:create(3.0, 200),--FIXME:无敌时间
            }),
            
            cc.CallFunc:create(function()
                --无敌时间已过
                self:getEntity():setOpacity(255)
                self:getEntity():setVisible(true)
                myHealthComp:setInvincible(false)
                
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
function M:_onAdded(entity)
    M.super._onAdded(self,entity)

    --由于这个语句会触发_onStart(),因此在实体类中需要调整脚本顺序
    entity:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)  
end

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