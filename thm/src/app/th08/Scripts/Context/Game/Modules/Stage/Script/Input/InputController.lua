local M = class("InputController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

end
--
function M:_onStart()
    local inputComp = self:getComponent("InputComponent")
    local keyMapper = inputComp.keyMapper

    self:_onRegister(keyMapper)
end
function M:_onUpdate()
    local inputComp = self:getComponent("InputComponent")
    self:_onHandle(inputComp)
end

----
--[[有子类重写]]
function M:_onRegister(keyMapper)
    
end

function M:_onHandle(inputComp)

end

return M