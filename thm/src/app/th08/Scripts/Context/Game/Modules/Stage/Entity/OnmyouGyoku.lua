module(..., package.seeall)

local M = class("OnmyouGyoku",StageDefine.WingmanPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    --阴阳玉有拖尾的效果
    self.animationController = StageDefine.OnmyouGyokuAnimation.new()
    self:addScript(self.animationController)

    self.wingmanController = StageDefine.OnmyouGyokuController.new()
    self:addScript(self.wingmanController)

    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitterMainCtrl = self.emitter:getScript("EmitterController")
    self.emitterMainCtrl.objectPrefab = StageDefine.OnmyouGyokuBulletPrefab
    self.emitterMainCtrl.shotInterval = 0.4
    self:addChild(self.emitter)

end



return M