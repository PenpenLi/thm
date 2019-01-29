
local M = class("PlayerBulletCollision",StageDefine.BulletCollision)

---
function M:_onFilter()
    --TODO:特异性
    return {
        ignore = {
            ["PLAYER_BULLET"] = true,
            ["WINGMAN_BULLET"] = true,
            ["PLAYER"] = true,
            ["WINGMAN"] = true,
            ["EMITTER"] = true,
            ["GYOKU1"] = true,
            ["GYOKU2"] = true,
            ["PROP"] = true,
        }
    }
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