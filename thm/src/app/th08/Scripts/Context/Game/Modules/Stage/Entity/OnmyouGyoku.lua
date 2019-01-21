module(..., package.seeall)

local M = class("OnmyouGyoku",StageDefine.WingmanPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    --阴阳玉有拖尾的效果
    self.wingmanController = StageDefine.OnmyouGyokuController.new()
    self:addScript(self.wingmanController)

    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitter:setName("EMITTER")
    self:addChild(self.emitter)
    local emitterController = self.emitter:getScript("EmitterController")
    emitterController.bulletPrefab = StageDefine.OnmyouGyokuBulletPrefab
    emitterController.shotInterval = 0.08

    debugUI(self)
end



return M