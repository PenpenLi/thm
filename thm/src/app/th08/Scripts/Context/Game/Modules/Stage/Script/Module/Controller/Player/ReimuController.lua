

local M = class("ReimuController",StageDefine.PlayerController)
local WINGMAN_SLOW_ON_POS = cc.p(15,10)
local WINGMAN_SLOW_OFF_POS = cc.p(30,-8)
local EMITTER_INIT_SHOT_SPEED = cc.p(2,10)
local WINGMAN_AROUND_SPEED = 0.3


function M:_onInit()
    M.super._onInit(self)
    self.roleType = RoleType.REIMU

    --阴阳玉僚机
    self.wingman1 = nil
    self.wingman2 = nil

    --僚机发射口控制器
    self._wingman1EmitterCtrl = nil
    self._wingman2EmitterCtrl = nil

    --僚机的行为组件
    self._wingman1ActionComp = nil
    self._wingman2ActionComp = nil

end

function M:shot()
    M.super.shot(self)

    self._wingman1EmitterCtrl:shot()
    self._wingman2EmitterCtrl:shot()

    SoundManager.playEffect(200101)
end

function M:_onStart()
    M.super._onStart(self)

    --取得僚机实体
    self.wingman1 = self:getEntity():getChildByName("GYOKU1")
    self.wingman2 = self:getEntity():getChildByName("GYOKU2")
    
    self.wingman1:setPosition(cc.p(-WINGMAN_SLOW_OFF_POS.x,WINGMAN_SLOW_OFF_POS.y))
    self.wingman2:setPosition(cc.p(WINGMAN_SLOW_OFF_POS.x,WINGMAN_SLOW_OFF_POS.y))

    self._wingman1EmitterCtrl = self.wingman1:getChildByName("EMITTER"):getScript("EmitterController")
    self._wingman2EmitterCtrl = self.wingman2:getChildByName("EMITTER"):getScript("EmitterController")
    ---
    -- FIXME:修改炮口方向(这里是改物体方向还是发射初速度,有待商讨)
    self._wingman1EmitterCtrl.shotSpeed = cc.p(-EMITTER_INIT_SHOT_SPEED.x,EMITTER_INIT_SHOT_SPEED.y)
    self._wingman2EmitterCtrl.shotSpeed = cc.p(EMITTER_INIT_SHOT_SPEED.x,EMITTER_INIT_SHOT_SPEED.y)
    ---
    self._wingman1ActionComp = self.wingman1:getComponent("ActionComponent")
    self._wingman2ActionComp = self.wingman2:getComponent("ActionComponent")

    self._wingman1ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(3.14,3.14),centerPos = cc.p(0,WINGMAN_SLOW_OFF_POS.y)})))
    self._wingman2ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(0,0),centerPos = cc.p(0,WINGMAN_SLOW_OFF_POS.y)})))
end

function M:slow(val)
    M.super.slow(self,val)
    if val then
        self._wingman1ActionComp:stopAllActions()
        self._wingman2ActionComp:stopAllActions()

        self._wingman1ActionComp:runAction(cc.MoveTo:create(0.1,cc.p(-WINGMAN_SLOW_ON_POS.x,WINGMAN_SLOW_ON_POS.y)))
        self._wingman2ActionComp:runAction(cc.MoveTo:create(0.1,cc.p(WINGMAN_SLOW_ON_POS.x,WINGMAN_SLOW_ON_POS.y)))

        self._wingman1EmitterCtrl.shotSpeed = cc.p(0,EMITTER_INIT_SHOT_SPEED.y)
        self._wingman2EmitterCtrl.shotSpeed = cc.p(0,EMITTER_INIT_SHOT_SPEED.y)
    else
        self._wingman1ActionComp:runAction(cc.Sequence:create({
            cc.MoveTo:create(0.1,cc.p(-WINGMAN_SLOW_OFF_POS.x,WINGMAN_SLOW_OFF_POS.y)),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(function()
                self._wingman1EmitterCtrl.shotSpeed = cc.p(-EMITTER_INIT_SHOT_SPEED.x,EMITTER_INIT_SHOT_SPEED.y)
                self._wingman1ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(3.14,3.14),centerPos = cc.p(0,WINGMAN_SLOW_OFF_POS.y)})))
            end)
        }))
        self._wingman2ActionComp:runAction(cc.Sequence:create({
            cc.MoveTo:create(0.1,cc.p(WINGMAN_SLOW_OFF_POS.x,WINGMAN_SLOW_OFF_POS.y)),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(function()
                self._wingman2EmitterCtrl.shotSpeed = cc.p(EMITTER_INIT_SHOT_SPEED.x,EMITTER_INIT_SHOT_SPEED.y)
                self._wingman2ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(0,0),centerPos = cc.p(0,WINGMAN_SLOW_OFF_POS.y)})))
            end)
        }))

        
        

    end
end


return M