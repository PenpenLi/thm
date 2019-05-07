module(..., package.seeall)

local M = class("OnmyouGyokuBullet",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)


end

return M