
local M = class("WingmanBulletCollision",StageDefine.BulletCollision)

---
function M:_onFilter()
    --TODO:特异性
    return {"PLAYER_BULLET","WINGMAN_BULLET","PLAYER","WINGMAN","EMITTER","GYOKU1","GYOKU2"}
end

function M:_onCollision(collider,collision)
    M.super._onCollision(self,collider,collision)
    
    local myHealthScript = self:getScript("HealthController")         --子弹自身
    if not myHealthScript:isDead() then
        local colliderHealthScript = collider:getScript("HealthController")--被击中物
        local bulletCtrl = self:getScript("BulletController")
        colliderHealthScript:hit(bulletCtrl:getLethality())      --伤害值由计算得出

        myHealthScript:die()                                --子弹阵亡
    end
    
    --停止移动
    local rigidbodyComp = self:getComponent("RigidbodyComponent")
    rigidbodyComp:setSpeed(0,0)
end

return M