local M = class("CollisionController",THSTG.ECS.Script)
function M:_onInit()
    self._baseData = false
    self._collider = false
end

function M:_onAwake()
    --重新设置下
    self._collider = self:getComponent("ColliderComponent")
    self._baseData = self:getScript("EntityBasedata")
    local code = self._baseData:getEntityCode()
    local shapeCfg = self._baseData:getData():getShapeData()
    if shapeCfg then
        if self._collider:getType() == 1 then
            self._collider.size = cc.size(shapeCfg.collider.width,shapeCfg.collider.height)
        elseif self._collider:getType() == 2 then
            self._collider.radius = shapeCfg.radius
        end
    else
        --按照
        local aminaCtrl = self:getScript("AnimationController")
        local size = aminaCtrl:getSprite():getContentSize() --FIXME:纯动画的大小无法通过第一帧获取到
        self._collider.size = size
    end

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
--屏蔽Tag
function M:_onFilter()

end
--碰撞回调
function M:_onCollision(collider,collision)

end

return M