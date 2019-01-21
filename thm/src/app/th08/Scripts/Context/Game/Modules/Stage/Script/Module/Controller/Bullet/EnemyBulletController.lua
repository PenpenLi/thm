local M = class("EnemyBulletController",StageDefine.BulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = 0
    self.speed = cc.p(0,-10)

end
---


return M