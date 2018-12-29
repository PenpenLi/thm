local M = class("BulletController",THSTG.ECS.Script)

function M:_onInit()
    self.belong = 0
    self.type = false
    self.speed = cc.p(0,10)     --正方向为上
    self.rotation = 0
end
--
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite
    sprite:setRotation(self.rotation)
    
    sprite:runAction(cc.RepeatForever:create(
        cc.Animate:create(AnimationCache.getSheetRes("reimu_bullet_01_normal"))
    ))
 
    
end

function M:_moveHandle()
    local posComp = self:getComponent("TransformComponent")
    posComp:setPositionY(posComp:getPositionY() + self.speed.y)
end

---
function M:_onUpdate(delay)
    self:_moveHandle()


end

return M