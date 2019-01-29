local M = class("PlayerCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {
        ignore = {
            ["PLAYER_BULLET"] = true,
            ["PLAYER"] = true,
        }
    }
end

function M:_onCollision(collider,collision)
    local myHealthScript = self:getScript("PlayerHealth")         --子弹自身
    if not myHealthScript:isDead() then
        myHealthScript:dying() 
        --TODO:被弹数+1
    end
end

return M