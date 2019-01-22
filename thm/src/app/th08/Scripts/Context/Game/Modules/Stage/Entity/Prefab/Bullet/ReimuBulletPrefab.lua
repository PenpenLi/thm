module(..., package.seeall)

local M = class("ReimuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.bulletController = StageDefine.ReimuBulletController.new()
    self:addScript(self.bulletController)

    self.animationController = StageDefine.ReimuBulletAnimation.new()
    self:addScript(self.animationController)

    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end



return M