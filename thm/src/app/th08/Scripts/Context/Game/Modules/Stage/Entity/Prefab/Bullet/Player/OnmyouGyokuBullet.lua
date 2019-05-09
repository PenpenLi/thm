module(..., package.seeall)

local M = class("OnmyouGyokuBullet",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.entityData:setDataByCode(10500002)
end

return M