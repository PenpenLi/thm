local M = class("CollisionController",THSTG.ECS.Script)
function M:_onInit()
    self._baseData = false
    self._collider = false
end

function M:_onAwake()

end

function M:_onStart()
    self._collider = self:getComponent("ColliderComponent")
    self._baseData = self:getScript("EntityBasedata")
    self._aminaCtrl = self:getScript("AnimationController")
    self:_onBody()
end

function M:_onEnd()

end

function M:getFilter()
    return self:_onFilter()
end

function M:collide(collider,collision)
    return self:_onCollision(collider,collision)
end


---
function M:_onBody()
    local code = self._baseData:getEntityCode()
    local shapeCfg = self._baseData:getData():getShapeData()
    if shapeCfg then
        if self._collider:getType() == 1 then
            self._collider.size = cc.size(shapeCfg.collider.width,shapeCfg.collider.height)
        elseif self._collider:getType() == 2 then
            self._collider.radius = shapeCfg.radius
        end
    else
        -- 取动画组件的大小
        local size = self._aminaCtrl:getSize()
        self._collider.size = size
    end
end
--屏蔽Tag
function M:_onFilter()

end

--碰撞回调
function M:_onCollision(collider,collision)

end

return M