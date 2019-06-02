local M = class("SpellController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self._baseData = false
end

-------
-------
--[[子类重载]]
function M:bomb()

end

function M:_onStart()
    self._baseData = self:getScript("EntityBasedata")
end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M