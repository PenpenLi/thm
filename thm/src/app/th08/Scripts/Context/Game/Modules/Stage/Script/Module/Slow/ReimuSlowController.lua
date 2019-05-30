local M = class("ReimuSlowController",StageDefine.SlowController)
M.WINGMAN_SLOW_POS = cc.p(15,10)
function M:_onInit()
    M.super._onInit(self)

    --灵梦组件
    self.reimuCtrl = nil

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

function M:_onStart()
    M.super._onStart(self)
    --
    self.reimuCtrl = self:getScript("ReimuController")
    --取得僚机实体
    self.wingman1 = self:getEntity():findChild("GYOKU1")
    self.wingman2 = self:getEntity():findChild("GYOKU2")

    self._wingman1EmitterCtrl = self.wingman1:findChild("EMITTER"):getScript("EmitterController")
    self._wingman2EmitterCtrl = self.wingman2:findChild("EMITTER"):getScript("EmitterController")

    self._wingman1ActionComp = self.wingman1:getComponent("ActionComponent")
    self._wingman2ActionComp = self.wingman2:getComponent("ActionComponent")
end


function M:_onSlowOpen()
    self._wingman1ActionComp:stopAll()
    self._wingman2ActionComp:stopAll()

    self._wingman1ActionComp:runOnce(cc.MoveTo:create(0.1,cc.p(-M.WINGMAN_SLOW_POS.x,M.WINGMAN_SLOW_POS.y)))
    self._wingman2ActionComp:runOnce(cc.MoveTo:create(0.1,cc.p(M.WINGMAN_SLOW_POS.x,M.WINGMAN_SLOW_POS.y)))

    self._wingman1EmitterCtrl.shotSpeed = cc.p(0,self.reimuCtrl.EMITTER_INIT_SHOT_SPEED.y)
    self._wingman2EmitterCtrl.shotSpeed = cc.p(0,self.reimuCtrl.EMITTER_INIT_SHOT_SPEED.y)
end

function M:_onSlowClose()
    self.reimuCtrl:wingmanReset()
end

return M