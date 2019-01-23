local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

local M = class("PlayerController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    self.roleType = false                  --TODO:

    self.bombCount = 3                              --Bomb次数
    self.wipeRestTime = 5                           --wipe的剩余时间

    --TODO:以下具有特异性
    self.mainEmitter = nil                           --主发射器实体

    ---
    -- ObjectCache.expand(StageDefine.PlayerBulletPrefab,6)        --最大5颗,与子弹速度有关
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
    local emitterCtrl = self.mainEmitter:getScript("EmitterController")
    emitterCtrl:shot()
end

function M:bomb()
    if self.bombCount <= 0 then return end
    print(15,"炸弹")
    

    self.bombCount = self.bombCount - 1
    --TODO:决死效果

    THSTG.Dispatcher.dispatchEvent(EventType.STAGE_PLAYER_SPELLCARD_ATTACK,{roleType = self.roleType,isDeadSave = false})
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
    self:_onSlow(state)
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
-----
function M:_onSlow(val)

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

    --取得主发射口
    self.mainEmitter = self:getEntity():getChildByName("EMITTER")
    --僚机发射口
    self.wingman1 = self:getEntity():getChildByName("GYOKU1")
    self.wingman2 = self:getEntity():getChildByName("GYOKU2")

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