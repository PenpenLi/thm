local EWingmanType = GameDef.Stage.EWingmanType
local M = class("OnmyouGyokuController",StageDefine.WingmanController)

function M:_onInit()
    M.super._onInit(self)

    self.wingmanType = EWingmanType.OnmyouGyoku
    --存储子弹
end

function M:_onAdded(entity)
   M.super._onAdded(self,entity)
end

function M:_onStart()
    local emitterController = self:getEntity():getChildByName("EMITTER"):getScript("EmitterController")
    emitterController.objectPrefab = StageDefine.OnmyouGyokuBulletPrefab
    emitterController.shotInterval = 0.4
    emitterController.shotSpeed = cc.p(0,10)
end

function M:_onUpdate()
    --TODO:属于追踪弹,搜索自身8格子范围内的敌人锁定追踪
end



return M