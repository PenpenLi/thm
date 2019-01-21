local M = class("DestroyByTime",THSTG.ECS.Script)

function M:_onInit()
    self.dwellTime = 10  --s
    
    self._totalTime = 0
end
---
function M:reset()
    self._totalTime = 0
end
---
function M:_onUpdate(delay,entity)
    self._totalTime = self._totalTime + delay
    if self._totalTime >= self.dwellTime then
        self._totalTime = 0
        if ObjectCache.release(self:getEntity()) then self:getEntity():setActive(false) else self:killEntity() end
    end
end

return M