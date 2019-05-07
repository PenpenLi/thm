local M = class("BulletAnimation",StageDefine.BulletAnimation)

function M:_onInit()
    M.super._onInit(self)
    --
    self.rotation = -90
    self.centerPoint = cc.p(0.875,0.5)
end

function M:_onStart()
    M.super._onStart(self)
end

return M