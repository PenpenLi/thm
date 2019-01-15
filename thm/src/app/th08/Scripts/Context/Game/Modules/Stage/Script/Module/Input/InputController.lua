local M = class("InputController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.keyMapper = THSTG.UTIL.newControlMapper()
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
--按键注册
function M:_onRegister(keyMapper)
    
end

--输入处理
function M:_onHandle(inputComp)

end

return M