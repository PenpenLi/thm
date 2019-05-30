local EGameKeyType = GameDef.Public.EGameKeyType
local ETouchExType = GameDef.Public.ETouchExType

local M = class("PlayerController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    self.roleType = false                  

    self._shotCtrl = nil                           --主发射器实体
    self._bombCtrl = nil                              --Spell(bomb)
    self._wipeCtrl = nil                              --消弹
    self._slowCtrl = nil                              --低速

    self._spriteNode = nil
end


----------
function M:move(dx,dy)
    if self.__isLockMove then return end --重设阶段不能移动
    if self._slowCtrl:isSlow() then
        --低速模式速度减半
        dx = dx / 2 
        dy = dy / 2
    end
    M.super.move(self,dx,dy)
    
    ---状态模块
    if dx ~= 0 then self.fsm:doEvent("Move")
    else self.fsm:doEvent("Idle")
    end
end

function M:shot()
    self._shotCtrl:shot()
    
    --TODO:疯狂掉帧
    -- SoundManager.playEffect(200101)
end

function M:bomb()
    self._bombCtrl:bomb()
end

function M:wipe(state)
    self._wipeCtrl:wipe(state)

end

function M:slow(state)
    self._slowCtrl:slow(state)
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
    actionComp:runCustom(cc.Spawn:create({
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
            cc.CallFunc:create(function()
                myHealthComp:invincible() 
            end)
        })
    }))

end
-----
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

    --各部分
    self._bombCtrl = self:getEntity():getScript("SpellController")                           
    self._wipeCtrl = self:getEntity():getScript("WipeController")
    self._slowCtrl = self:getEntity():getScript("SlowController")
    
    --取得主发射口脚本节点
    self._shotCtrl = self:getEntity():findChild("EMITTER"):getScript("EmitterController")

    --取得动画节点
    self._spriteNode = self:getEntity():findChild("SPRITE_NODE")

end

function M:_onUpdate()
    
end

function M:_onLateUpdate()

end

function M:_onEnd()
    
end
-------------


return M