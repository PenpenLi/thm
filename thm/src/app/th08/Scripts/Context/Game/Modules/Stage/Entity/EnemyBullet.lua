module(..., package.seeall)

local M = class("EnemyBullet",StageDefine.BatmanPrefab)

function M:ctor()
    M.super.ctor(self)
   
    self.bulletController.belong = "ENEMY"

end





return M