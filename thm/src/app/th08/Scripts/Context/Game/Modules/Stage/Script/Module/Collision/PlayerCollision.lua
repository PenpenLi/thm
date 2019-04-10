local EEntityType = GameDef.Stage.EEntityType
local M = class("PlayerCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {
        ignore = {
            ["PLAYER_BULLET"] = true,
            ["PLAYER"] = true,
            ["WINGMAN_BULLET"] = true,
            ["WINGMAN"] = true,
            ["PROP"] = true,
        }
    }
end

function M:_onCollision(collider,collision)
    -- local colliderEntityType = collider:getScript("EntityController"):getEntityType()
    -- if colliderEntityType == EEntityType.Prop then
    
    -- else
        local myHealthScript = self:getScript("PlayerHealth")         --子弹自身
        if not myHealthScript:isDead() then
            myHealthScript:dying() 
            --TODO:被弹数+1
        end
    -- end
end

return M