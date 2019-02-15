module(..., package.seeall)

local M = class("OnmyouGyokuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.bulletController = StageDefine.OnmyouGyokuBulletController.new()
    self:addScript(self.bulletController)

    self.animationController = StageDefine.OnmyouGyokuBulletAnimation.new()
    self:addScript(self.animationController)

    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
    
end



return M