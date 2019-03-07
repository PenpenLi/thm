local STAGE_VIEW_SIZE = Const.Stage.STAGE_VIEW_SIZE
local M = class("DestroyByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.border = cc.rect(-STAGE_VIEW_SIZE.width,-STAGE_VIEW_SIZE.height,3*STAGE_VIEW_SIZE.width,3*STAGE_VIEW_SIZE.height)
    
    self._posComp = nil
end
---
function M:_onStart()
    self._posComp = self:getComponent("TransformComponent")
end

function M:_onLateUpdate()
    local posPoint = cc.p(self._posComp:getPositionX(),self._posComp:getPositionY())
    if not cc.rectContainsPoint(self.border, posPoint) then
        self:getScript("EntityController"):destroy()
    end
end

return M