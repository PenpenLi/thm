local M = class("DestroyByBullet",THSTG.ECS.Script)

function M:_onInit()
    
    
end
---
function M:_onLateUpdate()
    local system = self:getSystem("CollisionSystem")
    if system then
        local isCollide,collider = system:isCollided(self:getEntity(),{"PLAYER_BULLET","PLAYER"})
        if isCollide then 
            self:killEntity()
            collider:destroy()
        end
    end
end

return M