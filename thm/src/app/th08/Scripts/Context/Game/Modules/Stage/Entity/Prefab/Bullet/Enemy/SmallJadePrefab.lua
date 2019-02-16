module(..., package.seeall)

local M = class("SmallJade",StageDefine.EnemyBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.EnemyBulletAnimation.new()
    self:addScript(self.animationController)

    self.bulletController = StageDefine.EnemyBulletController.new()
    self.bulletController.bulletType = BulletType.SMALLJADE
    self:addScript(self.bulletController)


    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
   
end

return M