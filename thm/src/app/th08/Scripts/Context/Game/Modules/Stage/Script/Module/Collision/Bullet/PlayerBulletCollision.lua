
local M = class("PlayerBulletCollision",StageDefine.BulletCollision)

function M:_onInit()
    M.super._onInit(self)

    self.rigidbodyComp = false
    self.healthScript = false

end

---
function M:_onAwake()
    self.rigidbodyComp = self:getComponent("RigidbodyComponent")
    self.healthScript = self:getScript("HealthController")               --子弹自身
end

function M:_onFilter()
    --特异性
    return {
        ignore = {
            ["PLAYER_BULLET"] = true,
            ["WINGMAN_BULLET"] = true,
            ["ENEMY_BULLET"] = true,
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
    
    if not self.healthScript:isDead() then
        local colliderHealthScript = collider:getScript("HealthController") --被击中物
        local bulletCtrl = self:getScript("BulletController")
        colliderHealthScript:hit(bulletCtrl:getLethality())                 --伤害值由计算得出

        self.healthScript:die()                                                --子弹阵亡
    end
    
    --停止移动
    self.rigidbodyComp:setSpeed(0,0)
end

return M