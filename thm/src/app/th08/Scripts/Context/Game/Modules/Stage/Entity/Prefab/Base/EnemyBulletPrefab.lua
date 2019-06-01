module(..., package.seeall)

local M = class("EnemyBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("ENEMY_BULLET")

    self.helthController = StageDefine.EnemyBulletHealth.new()
    self:addScript(self.helthController)
    
    self.animationController = StageDefine.EnemyBulletAnimation.new()
    self:addScript(self.animationController)

    self.collisionController = StageDefine.EnemyBulletCollision.new()
    self:addScript(self.collisionController)

    self.bulletController = StageDefine.EnemyBulletController.new()
    self:addScript(self.bulletController)

end

return M