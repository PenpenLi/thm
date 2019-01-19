local M = class("PlayerBulletController",StageDefine.BulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = -90
    self.speed = cc.p(0,15)
    self.centerPoint = cc.p(0.875,0.5)
end
---
function M:reset(refEntity)
    M.super.reset(self,refEntity)


end
---
function M:_onStart()
    M.super._onStart(self)
end

---
function M:_onUpdate(delay)

end

function M:_onLateUpdate()

end

return M