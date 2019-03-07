local M = class("CollisionController",THSTG.ECS.Script)
function M:_onInit()
    self.collisionSys = nil
end

function M:_onStart()
    self.collisionSys = self:getSystem("CollisionSystem")
end

function M:_onLateUpdate()
    --越界判断更高效
    if self.collisionSys then
        local filterStr = self:_onFilter()
        local isCollision,collision = self.collisionSys:isCollidedByGrids(self:getEntity(),filterStr)
        if isCollision then
            self:_onCollision(collision.collider,collision)
        end
    end
end
---
--屏蔽Tag
function M:_onFilter()

end
--碰撞回调
function M:_onCollision(collider,collision)

end

return M