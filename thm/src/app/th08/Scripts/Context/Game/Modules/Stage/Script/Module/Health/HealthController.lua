local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.blood = 100    --TODO:特异性

    self._isDead = false
    self.isInvincible = false
end
--
function M:hit(damage)
    if self.isInvincible then return end

    if (damage > 0) then self:_onHurt(damage)
    elseif (damage == 0) then self:_onMiss(damage)
    elseif (damage < 0) then self:_onCure(damage)
    end

    self:setBlood(self:getBlood() - damage)
end

function M:die()
    self:setBlood(0)
end

function M:isDead()
    return self._isDead
end

function M:isInvincible()
    return self.isInvincible
end

function M:setInvincible(val)
    self.isInvincible = val
end

function M:setBlood(val)
    if self:_onBlood(self.blood,val) == false then return end
    self.blood = val

    self._isDead = (self.blood <= 0)

    --
    if self._isDead then self:_onDead() end
end

function M:getBlood()
    return self.blood
end

----
--[[由子类重写]]
--受伤回调
function M:_onHurt(damage)

end

function M:_onMiss(damage)
    self:_onHurt(damage)
end

function M:_onCure(damage)
    self:_onHurt(damage)
end

--死亡回调
function M:_onDead()

end

--血量回调
function M:_onBlood(old,val)

end

return M