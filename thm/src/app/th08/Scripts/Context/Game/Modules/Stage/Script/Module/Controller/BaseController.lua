local M = class("BaseController",THSTG.ECS.Script)

function M:_onInit()
    self.fsm = THSTG.UTIL.newStateMachine() --状态机
end


------
function M:move(dx,dy)
    local transComp = self:getComponent("TransformComponent")
    transComp:setPositionX(transComp:getPositionX() + dx)
    transComp:setPositionY(transComp:getPositionY() + dy)
end
------
--[[由子类进行重载]]
function M:_onState()

end

-------
function M:_onStart()
    local cfg = self:_onState()
    if cfg and next(cfg) then
        self.fsm:setupState(cfg)
    end
end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M