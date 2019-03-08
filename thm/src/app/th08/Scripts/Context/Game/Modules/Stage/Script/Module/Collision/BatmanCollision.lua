local M = class("PorpCollision",StageDefine.CollisionController)

---
function M:_onInit()
    M.super._onInit(self)


end

function M:_onFilter()
    return {
        match = {
            ["PLAYER_BULLET"] = true,
            ["WINGMAN_BULLET"] = true,
        }
    }
end

function M:_onCollision(collider,collision)
    
end

function M:_onStart()

end

return M