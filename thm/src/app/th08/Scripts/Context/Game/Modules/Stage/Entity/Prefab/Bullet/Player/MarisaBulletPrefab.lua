module(..., package.seeall)

local M = class("MarisaBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.MarisaBulletAnimation.new()
    self:addScript(self.animationController)
    

end

return M