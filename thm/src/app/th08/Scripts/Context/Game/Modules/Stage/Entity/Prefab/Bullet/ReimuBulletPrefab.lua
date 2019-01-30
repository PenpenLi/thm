module(..., package.seeall)

local M = class("ReimuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.ReimuBulletAnimation.new()
    self:addScript(self.animationController)
    
    self.bulletController = StageDefine.ReimuBulletController.new()
    self:addScript(self.bulletController)

    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end



return M