module(..., package.seeall)

local M = class("EnemyBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("ENEMY_BULLET")

    self.helthController = StageDefine.EnemyBulletHealth.new()
    self:addScript(self.helthController)

    self.bulletController = StageDefine.EnemyBulletController.new()
    self:addScript(self.bulletController)


    ----
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end





return M