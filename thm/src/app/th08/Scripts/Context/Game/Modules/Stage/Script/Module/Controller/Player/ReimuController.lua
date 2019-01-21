

local M = class("ReimuController",StageDefine.PlayerController)

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
end

function M:_onStart()
    M.super._onStart(self)

    --取得僚机实体
    self.wingman1 = self:getEntity():getChildByName("GYOKU1")
    self.wingman2 = self:getEntity():getChildByName("GYOKU2")

    self._wingman1EmitterCtrl = self.wingman1:getChildByName("EMITTER"):getScript("EmitterController")
    self._wingman2EmitterCtrl = self.wingman2:getChildByName("EMITTER"):getScript("EmitterController")

    self._wingman1ActionComp = self.wingman1:getComponent("ActionComponent")
    self._wingman2ActionComp = self.wingman2:getComponent("ActionComponent")

    -- self._wingman1ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(0.3,30,1,{delayTime = -3.14/2})))
    -- self._wingman2ActionComp:runAction(cc.RepeatForever:create(THSTG.ACTION.newMoveOvalBy(0.3,30,1,{delayTime = 3.14/2})))
end

function M:_onSlow(val)
    if val then
        self._wingman1ActionComp:runAction(cc.MoveBy:create(0.1,cc.p(7,10)))
        self._wingman2ActionComp:runAction(cc.MoveBy:create(0.1,cc.p(-7,10)))
    else
        self._wingman1ActionComp:runAction(cc.MoveBy:create(0.1,cc.p(-7,-10)))
        self._wingman2ActionComp:runAction(cc.MoveBy:create(0.1,cc.p(7,-10)))
    end
end


return M