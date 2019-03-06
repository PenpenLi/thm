module(..., package.seeall)

local M = class("PlayerBulletPrefab",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("PLAYER_BULLET")

    self.helthController = StageDefine.PlayerBulletHealth.new()
    self:addScript(self.helthController)

    self.collisionController = StageDefine.PlayerBulletCollision.new()
    self:addScript(self.collisionController)

    --
    self.entityCtrl.entityType = Const.Stage.EEntityType.PlayerBullet

end



return M