module(..., package.seeall)

local M = class("ReimuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.ReimuBulletAnimation.new()
    self:addScript(self.animationController)
    


end

return M