local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end
--
function M:getBulletType()
    local bulletControScript = self:getScript("BulletController")
    return bulletControScript.bulletType
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