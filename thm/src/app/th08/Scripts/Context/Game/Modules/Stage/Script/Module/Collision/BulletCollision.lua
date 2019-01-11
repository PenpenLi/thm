
local M = class("BulletCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {"PLAYER_BULLET","PLAYER"}
end

function M:_onCollision(collider,collision)
    local myHealthScript = self:getScript("HealthController")         --被击中物
    if not myHealthScript:isDead() then
        local colliderHealthScript = collider:getScript("HealthController")--被击中物
        colliderHealthScript:hurt(100)--TODO:伤害值由计算得出
        myHealthScript:hurt(9999)--TODO:伤害值由计算得出
    end
    
    local moveScript = self:getScript("MoveController")
    moveScript:stop()
end

return M