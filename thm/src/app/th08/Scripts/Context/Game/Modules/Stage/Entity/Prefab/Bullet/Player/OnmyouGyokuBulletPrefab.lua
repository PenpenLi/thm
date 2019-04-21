module(..., package.seeall)

local M = class("OnmyouGyokuBulletPrefab",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.OnmyouGyokuBulletAnimation.new()
    self:addScript(self.animationController)

end

return M