local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.blood = 100    --TODO:特异性

    self._isDead = false
    self._isHurt = false
end
--
function M:hurt(damage)
    self._isHurt = (damage > 0)
    self:setBlood(self:getBlood()- damage)
end

function M:die()
    self:setBlood(0)
end

function M:isDead()
    return self._isDead
end

function M:isHurt()
    return self._isHurt
end

function M:setBlood(val)
    if self:_onBlood(self.blood,val) == false then return end
    self.blood = val

    self._isDead = (self.blood <= 0)
end

function M:getBlood()
    return self.blood
end


--
function M:_onLateUpdate()
    if self._isHurt then self:_onHurt() end
    if self._isDead then self:_onDead() end

    if self._isHurt then self._isHurt = false end
end

----
--[[由子类重写]]
--受伤回调
function M:_onHurt()


end
--死亡回调
function M:_onDead()

end

--血量回调
function M:_onBlood(old,val)

end

return M