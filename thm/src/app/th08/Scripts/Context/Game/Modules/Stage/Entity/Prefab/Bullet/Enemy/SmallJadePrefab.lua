module(..., package.seeall)

local M = class("SmallJade",StageDefine.EnemyBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.EnemyBulletAnimation.new()
    self:addScript(self.animationController)

    self.bulletController = StageDefine.EnemyBulletController.new()
    self.bulletController.bulletType = Const.Stage.EEnemyBulletType.SmallJade
    self:addScript(self.bulletController)

   
end

return M