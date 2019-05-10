module(..., package.seeall)
local M = class("OnmyouGyoku",StageDefine.WingmanPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    self.spriteNode:addScript(StageDefine.AutoRotationScript.new()) --让僚机动画自旋
    
    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitterMainCtrl = self.emitter:getScript("EmitterController")
    self:addChild(self.emitter)

    --
    self.emitterMainCtrl.bulletCode = 10500002

end

return M