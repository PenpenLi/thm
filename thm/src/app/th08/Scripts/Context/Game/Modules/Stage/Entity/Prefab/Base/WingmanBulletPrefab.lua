module(..., package.seeall)

local M = class("WingmanBulletPrefab",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("WINGMAN_BULLET") 

    self.helthController = StageDefine.WingmanBulletHealth.new()
    self:addScript(self.helthController)

    self.animationController = StageDefine.WingmanBulletAnimation.new()
    self:addScript(self.animationController)
    
    self.collisionController = StageDefine.WingmanBulletCollision.new()
    self:addScript(self.collisionController)

    self.bulletController = StageDefine.WingmanBulletController.new()
    self:addScript(self.bulletController)
end



return M