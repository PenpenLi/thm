module(..., package.seeall)

local M = class("OnmyouGyokuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.bulletController = StageDefine.ReimuBulletController.new()
    self:addScript(self.bulletController)

    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end



return M