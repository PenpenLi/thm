module(..., package.seeall)

local M = class("SmallJade",StageDefine.EnemyBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.EnemyBulletAnimation.new()
    self:addScript(self.animationController)

    self.bulletController.bulletType = GameDef.Stage.EEnemyBulletType.SmallJade
end

return M