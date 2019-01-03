local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.life = 10

    self._isDead = false
    self._isHurt = false
end
--
function M:hurt(damage)
    self.life = self.life - damage
    self._isHurt = (damage > 0)
    self._isDead = (self.life <= 0)
end

function M:isDead()
    return self._isDead
end

function M:isHurt()
    return self._isHurt
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