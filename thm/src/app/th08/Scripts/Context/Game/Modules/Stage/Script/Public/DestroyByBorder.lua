local M = class("DestroyByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.boarder = cc.rect(-display.width,-display.height,2*display.width,2*display.height)
    
end
---
function M:_onLateUpdate()
    local posComp = self:getComponent("TransformComponent")
    local posPoint = cc.p(posComp:getPositionX(),posComp:getPositionY())
    if not cc.rectContainsPoint(self.boarder, posPoint) then
        if ObjectCache.release(self:getEntity()) then self:getEntity():setActive(false) else self:killEntity() end
    end
end

return M