local M = class("PlayerCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {"PLAYER_BULLET","PLAYER"}
end

function M:_onCollision(collider,collision)
    local myHealthScript = self:getScript("HealthController")         --子弹自身
    if not myHealthScript:isDead() then
        myHealthScript:die()   --TODO:被弹数+1
        --TODO:剩余的死亡操作,如决死
    end
end

return M