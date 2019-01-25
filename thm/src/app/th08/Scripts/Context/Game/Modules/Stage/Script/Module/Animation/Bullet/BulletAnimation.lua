local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = 0                   --初始角度  
    self.centerPoint = cc.p(0.5,0.5)    --中心点
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

    --进行碰撞点与贴图的位置修正
    local spriteComp =  self:getComponent("SpriteComponent")
    spriteComp:setAnchorPoint(self.centerPoint)
    spriteComp:setRotation(self.rotation)
end

---


----

return M