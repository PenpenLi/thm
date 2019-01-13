local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.blood = 100

    self._isDead = false
    self._isHurt = false
end
--
function M:hurt(damage)
    self.blood = self.blood - damage 
    self._isHurt = (damage > 0)
    self._isDead = (self.blood <= 0)
end

function M:isDead()
    return self._isDead
end

function M:isHurt()
    return self._isHurt
end

function M:setBlood(val,isRefresh)
    self.blood = val
    if isRefresh then self:hurt(0) end
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
function M:_onHurt()


end

function M:_onDead()

end

return M