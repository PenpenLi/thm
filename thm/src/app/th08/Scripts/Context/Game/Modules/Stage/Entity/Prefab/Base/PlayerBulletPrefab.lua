module(..., package.seeall)

local M = class("PlayerBulletPrefab",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("PLAYER_BULLET")

    self.helthController = StageDefine.PlayerBulletHealth.new()
    self:addScript(self.helthController)

    self.collisionController = StageDefine.PlayerBulletCollision.new()
    self:addScript(self.collisionController)

    self.bulletController = StageDefine.PlayerBulletController.new()
    self:addScript(self.bulletController)

    --
    self.entityCtrl.entityType = GameDef.Stage.EEntityType.PlayerBullet

end



return M