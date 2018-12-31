local M = class("ColliderComponent",THSTG.ECS.Component)
M.EColliderType = {Rect = 1,Circle = 2}
-----
function M:_onInit()
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
-- 可能有多个碰撞体组成一个整体
function M:_onClass(className,id)
    return className
end

function M:_onAdded(entity)
    
end

function M:_onRemoved(entity)
    
end

function M:_onUpdate(delay,entity)
    
end

function M:_onLateUpdate(delay,entity)

end

function M:_onCollide(collder)
    
end

return M