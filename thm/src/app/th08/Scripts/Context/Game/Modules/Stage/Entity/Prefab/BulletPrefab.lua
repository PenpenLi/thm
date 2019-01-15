module(..., package.seeall)

local M = class("BulletPrefab",StageDefine.BulletEntity)

function M:ctor()
    M.super.ctor(self)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    self.helthController = StageDefine.BulletHealth.new()
    self:addScript(self.helthController)

    self.collisionController = StageDefine.BulletCollision.new()
    self:addScript(self.collisionController)

    self.animationController = StageDefine.BulletAnimation.new()
    self:addScript(self.animationController)
 
end

----------


return M