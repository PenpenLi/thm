local M = class("PropController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.propType = false
end
---

function M:getPropType()
    return self.propType
end

function M:effect(refEntity)
    --被拾取
    self:_onEffect()
    --音效,效果,消失
end

function M:reset(refEntity)

end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    

end
---
function M:_onStart()
 
end

function M:_onEffect()
    --TODO:效果效果
end
---


return M