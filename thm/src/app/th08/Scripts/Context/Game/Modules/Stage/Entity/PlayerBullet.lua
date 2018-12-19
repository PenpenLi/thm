module(..., package.seeall)

local M = class("PlayerBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
   
    self.bulletController.belong = "PLAYER"
    self.bulletController.speed.y = 20
    self.bulletController.rotation = -90        --玩家子弹需要90度旋转

end



return M