local M = class("BatmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end
---
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
  
 
    
end
---
function M:_onLateUpdate()
    --主要根据移动方式判断动画
end

----

return M