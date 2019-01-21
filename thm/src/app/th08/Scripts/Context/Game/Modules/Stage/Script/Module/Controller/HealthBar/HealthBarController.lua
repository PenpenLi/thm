
local M = class("HealthBarController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self._healthBar = nil
end

function M:refresh(val,maxVal)
    self._healthBar:refresh(val,maxVal)
end
--
function M:_onStart()
    self._healthBar = self:getEntity():getChildByName("HEALTH_BAR")
end

return M