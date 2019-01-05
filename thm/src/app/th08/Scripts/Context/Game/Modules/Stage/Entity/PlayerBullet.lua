module(..., package.seeall)

local M = class("PlayerBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("PLAYER_BULLET")

    self.bulletMove.speed.y = 20
    self.animationController.rotation = -90        --这个仅由贴图决定

end



return M