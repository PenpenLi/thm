local M = class("DestoryByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.boarder = cc.rect(-display.width,-display.height,2*display.width,2*display.height)
    
end
---
function M:_onLateUpdate()
    local posComp = self:getComponent("PositionComponent")
    local posPoint = cc.p(posComp.x,posComp.y)
    if not cc.rectContainsPoint(self.boarder, posPoint) then
        self:destroy()
    end
end

return M