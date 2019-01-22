local M = class("BulletController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
    --FIXME:特异属性
    self.bulletType = false             --子弹类型
    self.rotation = 0                   --初始角度  
    self.centerPoint = cc.p(0.5,0.5)    --中心点
    self.lethality = 10                 --杀伤力               
end
---
function M:getBulletType()
    return self.bulletType
end

function M:getLethality()
    return self.lethality
end

function M:setLethality(val)
    self.lethality = val
end

function M:reset()
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:getSprite():setRotation(self.rotation)
    animationComp:getSprite():setOpacity(255)
    animationComp:getSprite():setScale(1)

    --重置生命值
    local bulletHealthComp = self:getScript("BulletHealth")
    bulletHealthComp:setBlood(100)
end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    

    entity:setActive(false)
end
---
function M:_onStart()
    M.super._onStart(self)
    --进行碰撞点与贴图的位置修正
    local spriteComp =  self:getComponent("SpriteComponent")
    spriteComp:setAnchorPoint(self.centerPoint)
    spriteComp:setRotation(self.rotation)
 
end

---


return M