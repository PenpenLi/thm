local M = class("ReimuBulletController",StageDefine.PlayerBulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = -90
    self.speed = cc.p(0,15)
    self.centerPoint = cc.p(0.875,0.5)
end
---


return M