local M = class("CollisionController",THSTG.ECS.Script)

function M:_onLateUpdate()
    local system = self:getSystem("CollisionSystem")
    if system then
        local filterStr = self:_onFilter()
        local isCollision,collision = system:isCollidedByGrids(self:getEntity(),filterStr)
        if isCollision then
            self:_onCollision(collision.collider,collision)
        end
    end
end
---

function M:_onFilter()

end

function M:_onDirection()
    
end

function M:_onCollision(collider,collision)

end

return M