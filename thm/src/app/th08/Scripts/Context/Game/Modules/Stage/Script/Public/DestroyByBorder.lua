local M = class("DestroyByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.border = cc.rect(-display.width,-display.height,3*display.width,3*display.height)
    
    self._posComp = nil
end
---
function M:_onStart()
    self._posComp = self:getComponent("TransformComponent")
end

function M:_onLateUpdate()
    local posPoint = cc.p(self._posComp:getPositionX(),self._posComp:getPositionY())
    if not cc.rectContainsPoint(self.border, posPoint) then
        if ObjectCache.release(self:getEntity()) then self:getEntity():setActive(false) else self:killEntity() end
    end
end

return M