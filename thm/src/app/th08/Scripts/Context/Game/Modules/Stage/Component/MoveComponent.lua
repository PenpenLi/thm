local M = class("MoveComponent",THSTG.ECS.Component)

function M:_onInit()
    self.x = 0
    self.y = 0
end

return M