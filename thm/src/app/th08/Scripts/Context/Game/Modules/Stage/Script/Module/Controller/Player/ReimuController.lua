
local ERoleType = GameDef.Stage.ERoleType
local M = class("ReimuController",StageDefine.PlayerController)
M.WINGMAN_INIT_POS = cc.p(30,-8)
M.EMITTER_INIT_SHOT_SPEED = cc.p(2,10)
M.WINGMAN_AROUND_SPEED = 0.3

function M:_onInit()
    M.super._onInit(self)

    self.roleType = ERoleType.Reimu

    --阴阳玉僚机
    self.wingman1 = nil
    self.wingman2 = nil

    --僚机发射口控制器
    self._wingman1EmitterCtrl = nil
    self._wingman2EmitterCtrl = nil

    --僚机的行为组件
    self._wingman1ActionComp = nil
    self._wingman2ActionComp = nil

    self._wipeCtrl = nil

end

function M:shot()
    M.super.shot(self)

    -- if not self._wipeCtrl:isWipe() then
        self._wingman1EmitterCtrl:shot()
        self._wingman2EmitterCtrl:shot()
    -- end

end

function M:_initWingman()
    self.wingman1:setPosition(cc.p(-M.WINGMAN_INIT_POS.x,M.WINGMAN_INIT_POS.y))
    self.wingman2:setPosition(cc.p(M.WINGMAN_INIT_POS.x,M.WINGMAN_INIT_POS.y))

    -- 修改炮口方向(这里是改物体方向还是发射初速度,有待商讨)
    self._wingman1EmitterCtrl.shotSpeed = cc.p(-M.EMITTER_INIT_SHOT_SPEED.x,M.EMITTER_INIT_SHOT_SPEED.y)
    self._wingman2EmitterCtrl.shotSpeed = cc.p(M.EMITTER_INIT_SHOT_SPEED.x,M.EMITTER_INIT_SHOT_SPEED.y)


    self._wingman1ActionComp:runCustom(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(M.WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(3.14,3.14),centerPos = cc.p(0,M.WINGMAN_INIT_POS.y)})))
    self._wingman2ActionComp:runCustom(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(M.WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(0,0),centerPos = cc.p(0,M.WINGMAN_INIT_POS.y)})))
end

function M:wingmanReset()
    self._wingman1ActionComp:stop()
    self._wingman2ActionComp:stop()
    self._wingman1ActionComp:runCustom(cc.Sequence:create({
        cc.MoveTo:create(0.1,cc.p(-M.WINGMAN_INIT_POS.x,M.WINGMAN_INIT_POS.y)),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            self._wingman1EmitterCtrl.shotSpeed = cc.p(-M.EMITTER_INIT_SHOT_SPEED.x,M.EMITTER_INIT_SHOT_SPEED.y)
            self._wingman1ActionComp:runCustom(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(M.WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(3.14,3.14),centerPos = cc.p(0,M.WINGMAN_INIT_POS.y)})))
        end)
    }))
    self._wingman2ActionComp:runCustom(cc.Sequence:create({
        cc.MoveTo:create(0.1,cc.p(M.WINGMAN_INIT_POS.x,M.WINGMAN_INIT_POS.y)),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            self._wingman2EmitterCtrl.shotSpeed = cc.p(M.EMITTER_INIT_SHOT_SPEED.x,M.EMITTER_INIT_SHOT_SPEED.y)
            self._wingman2ActionComp:runCustom(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(M.WINGMAN_AROUND_SPEED,30,3,{offset = cc.p(0,0),centerPos = cc.p(0,M.WINGMAN_INIT_POS.y)})))
        end)
    }))
end

function M:_onStart()
    M.super._onStart(self)
    --
    self._wipeCtrl = self:getScript("WipeController")
    --取得僚机实体
    self.wingman1 = self:getEntity():getChildByName("GYOKU1")
    self.wingman2 = self:getEntity():getChildByName("GYOKU2")
    
    self._wingman1EmitterCtrl = self.wingman1:getChildByName("EMITTER"):getScript("EmitterController")
    self._wingman2EmitterCtrl = self.wingman2:getChildByName("EMITTER"):getScript("EmitterController")

    self._wingman1ActionComp = self.wingman1:getComponent("ActionComponent")
    self._wingman2ActionComp = self.wingman2:getComponent("ActionComponent")
    ---
    self:_initWingman()
end


return M