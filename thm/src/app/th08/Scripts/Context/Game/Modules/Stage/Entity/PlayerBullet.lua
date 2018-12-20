module(..., package.seeall)

local M = class("PlayerBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
   
    self.bulletController.belong = "PLAYER"
    self.bulletController.speed.y = 20
    self.bulletController.rotation = -90        --这个仅由贴图决定
    
end



return M