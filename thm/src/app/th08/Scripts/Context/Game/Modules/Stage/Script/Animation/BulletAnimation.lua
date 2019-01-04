local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    self.rotation = 0
end
--
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite
    sprite:runAction(cc.Animate:create(AnimationCache.getSheetRes("reimu_bullet_01_normal")))
    sprite:setAnchorPoint(cc.p(0.875,0.5))
    sprite:setRotation(self.rotation)
    
end
--
function M:_onLateUpdate()

end

----

return M