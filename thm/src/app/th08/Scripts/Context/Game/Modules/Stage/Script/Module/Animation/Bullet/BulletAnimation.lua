local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
    self.bulletType = nil
end
--
function M:getBulletType()
    return self.bulletType
end

---
function M:_onStart()
    M.super._onStart(self)
  
    local bulletControScript = self:getScript("BulletController")
    self.bulletType = bulletControScript.bulletType
end

---


----

return M