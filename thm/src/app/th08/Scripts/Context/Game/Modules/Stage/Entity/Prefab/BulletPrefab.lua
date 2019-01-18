module(..., package.seeall)

local M = class("BulletPrefab",StageDefine.BulletEntity)

function M:ctor()
    M.super.ctor(self)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    self.animationController = StageDefine.BulletAnimation.new()
    self:addScript(self.animationController)
 
end

----------


return M