module(..., package.seeall)

local M = class("PlayerBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    self:setName("PLAYER_BULLET")

    self.bulletController = StageDefine.PlayerBulletController.new()
    self:addScript(self.bulletController)


end



return M