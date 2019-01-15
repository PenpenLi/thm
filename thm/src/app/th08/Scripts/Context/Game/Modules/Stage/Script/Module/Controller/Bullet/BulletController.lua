local M = class("BulletController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    self.bulletType = false --TODO:
    self.rotation = 0
    self.speed = cc.p(0,-10)
    self.centerPoint = cc.p(0.5,0.5)--TODO:中心点,这个属于子弹特异
end
---
function M:getBulletType()
    return self.bulletType
end

---
function M:_onStart()
    M.super._onStart(self)
     --进行碰撞点与贴图的位置修正
     local spriteComp =  self:getComponent("SpriteComponent")
     spriteComp:getSprite():setAnchorPoint(self.centerPoint)
     spriteComp:getSprite():setRotation(self.rotation)
 
     local rigidbodyComp = self:getComponent("RigidbodyComponent")
     rigidbodyComp:setSpeed(self.speed.x,self.speed.y)
end

---
function M:_onUpdate(delay)

end

function M:_onLateUpdate()

end

return M