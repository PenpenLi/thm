module(..., package.seeall)

local M = class("EnemyBullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
    
    self.bulletController = StageDefine.EnemyBulletController.new()
    self:addScript(self.bulletController)


end





return M