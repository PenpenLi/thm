
local M = class("BulletCollision",StageDefine.CollisionController)

---
function M:_onInit()
    M.super._onInit(self)

    -- self:setEnabled(false)
end

function M:_onFilter()
    
end

function M:_onCollision(collider,collision)
   
end

return M