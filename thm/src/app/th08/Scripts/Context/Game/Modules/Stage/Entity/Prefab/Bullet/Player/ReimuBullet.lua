module(..., package.seeall)

local M = class("ReimuBullet",StageDefine.PlayerBulletPrefab)
function M:ctor()
    M.super.ctor(self)

    self.entityData:setDataByCode(10500001)
end

return M