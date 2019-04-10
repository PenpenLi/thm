module(..., package.seeall)

local M = class("WingmanBulletPrefab",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("WINGMAN_BULLET") 

    self.helthController = StageDefine.WingmanBulletHealth.new()
    self:addScript(self.helthController)

    self.collisionController = StageDefine.WingmanBulletCollision.new()
    self:addScript(self.collisionController)

    --
    self.entityCtrl.entityType = GameDef.Stage.EEntityType.WingmanBullet
end



return M