local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.blood = 100
    self.isInvincible = false

    self._maxBlood = self.blood
    self._isDead = false

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
    self:hit(self.blood)
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

function M:setMaxBlood(val)
    self._maxBlood = val
end

function M:getMaxBlood()
    return self._maxBlood
end

function M:reset(val)
    self:setMaxBlood(val or self._maxBlood)
    self:setBlood(self:getMaxBlood())
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