module(..., package.seeall)
local M = class("OnmyouGyoku",StageDefine.WingmanPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    --阴阳玉有拖尾的效果

    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitterMainCtrl = self.emitter:getScript("EmitterController")
    self.emitterMainCtrl.objectPrefab = StageDefine.OnmyouGyokuBullet
    self.emitterMainCtrl.shotInterval = 0.4
    self:addChild(self.emitter)

    --
    self.entityData:setDataByCode(10200001)

end



return M