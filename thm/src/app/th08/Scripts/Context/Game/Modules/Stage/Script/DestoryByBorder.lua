local M = class("DestoryByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.boarder = cc.rect(-display.width,-display.height,2*display.width,2*display.height)
    
end
---
function M:_onLateUpdate()
    local posComp = self:getComponent("TransformComponent")
    local posPoint = cc.p(posComp:getPositionX(),posComp:getPositionY())
    if not cc.rectContainsPoint(self.boarder, posPoint) then
        self:getEntity():destroy()
    end
end

return M