module(..., package.seeall)

local M = class("EnemyBullet",StageDefine.BatmanPrefab)

function M:ctor()
    M.super.ctor(self)
   
    self.bulletMove.speed.y = -10

end





return M