module(..., package.seeall)

local M = class("PlayerBulletPrefab",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("PLAYER_BULLET")

    self.helthController = StageDefine.PlayerBulletHealth.new()
    self:addScript(self.helthController)

    self.collisionController = StageDefine.PlayerBulletCollision.new()
    self:addScript(self.collisionController)

    self.animationController = StageDefine.PlayerBulletAnimation.new()
    self:addScript(self.animationController)
    
    self.bulletController = StageDefine.PlayerBulletController.new()
    self:addScript(self.bulletController)



end



return M