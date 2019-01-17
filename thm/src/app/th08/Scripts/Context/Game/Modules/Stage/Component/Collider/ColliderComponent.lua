local M = class("ColliderComponent",THSTG.ECS.Component)
M.EColliderType = {Rect = 1,Circle = 2}
-----
function M:_onInit()
    self.tag = nil     --用于标识
    self.offset = cc.p(0,0)
    self.anchorPoint = cc.p(0.5,0.5)
    self.isTrigger = false

    self._type = nil
end
------
function M:collide(collder)
    return self:_onCollide(collder)
end

------


return M