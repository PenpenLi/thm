local M = class("PlayerWipeController",StageDefine.BulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = 0
    self.speed = cc.p(0,-10)

end
---

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