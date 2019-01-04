
local M = class("BulletCollision",StageDefine.CollisionController)

---
function M:_onFilter()
    return {"PLAYER_BULLET","PLAYER"}
end

function M:_onCollision(collider,collision)
    local colliderScript = collider:getScript("HealthController")--被击中物
    colliderScript:hurt(3)--TODO:伤害值由计算得出
    
    local myScript = self:getScript("HealthController")         --被击中物
    myScript:hurt(9999)--TODO:伤害值由计算得出
    self.speed = cc.p(0,0)  --停止运动
end

return M