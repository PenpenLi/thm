local M = class("PositionComponent",THSTG.ECS.Component)

function M:_onInit()
    self.x = 0
    self.y = 0
end

function M:_onUpdate(delay,entity)

end

function M:_onLateUpdate(delay,entity)
    entity:setPositionX(self.x)
    entity:setPositionY(self.y)
end

return M