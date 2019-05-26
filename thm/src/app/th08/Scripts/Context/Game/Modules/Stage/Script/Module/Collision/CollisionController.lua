local M = class("CollisionController",THSTG.ECS.Script)
function M:_onInit()
    
end

function M:_onStart()

end

function M:getFilter()
    return self:_onFilter()
end

function M:collide(collider,collision)
    return self:_onCollision(collider,collision)
end
---
--屏蔽Tag
function M:_onFilter()

end
--碰撞回调
function M:_onCollision(collider,collision)

end

return M