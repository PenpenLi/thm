local M = class("BatmanAnimation",StageDefine.AnimationController)

function M:_onInit()

end
---
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.RepeatForever:create(
        cc.Animate:create(AnimationCache.getSheetRes("enemy_01_a_normal"))
    ))
 
    
end
---
function M:_onLateUpdate()
    --主要根据移动方式判断动画
end

----

return M