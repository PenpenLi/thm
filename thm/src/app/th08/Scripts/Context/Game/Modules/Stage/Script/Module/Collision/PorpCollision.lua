local M = class("PorpCollision",StageDefine.CollisionController)

---
function M:_onInit()
    M.super._onInit(self)

    self.mainCtrl = nil
end

function M:_onFilter()
    return {
        match = {
            ["PLAYER"] = true,
        }
    }
end

function M:_onCollision(collider,collision)
    self.mainCtrl:effect(collider)
end

function M:_onStart()
    M.super._onStart(self)

    self.mainCtrl = self:getScript("PropController")
end

return M