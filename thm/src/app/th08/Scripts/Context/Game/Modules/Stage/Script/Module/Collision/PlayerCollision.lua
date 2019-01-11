local M = class("PlayerCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {"PLAYER_BULLET","PLAYER"}
end

function M:_onCollision(collider,collision)
    local script = self:getScript("HealthController")--被击中物
    script:hurt(100)--TODO:伤害值由计算得出
end

return M