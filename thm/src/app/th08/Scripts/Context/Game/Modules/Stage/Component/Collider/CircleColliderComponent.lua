local ColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.ColliderComponent")
local M = class("CircleColliderComponent",ColliderComponent)

function M:_onInit()
    M.super._onInit(self)
    self.radius = 8

    self._type = ColliderComponent.EColliderType.Circle
end

function M:getInSideRect()
    local entity = self:getEntity()
    local x = (entity:getPositionX() - self.anchorPoint.x * self.radius)
    local y = (entity:getPositionY() + self.anchorPoint.y * self.radius)
    return cc.rect(x + self.offset.x, y + self.offset.y, self.radius, self.radius)
end

function M:getOutSideRect()
    local entity = self:getEntity()
    local side = math.sqrt( 2 * self.radius * self.radius )
    local x = (entity:getPositionX() - self.anchorPoint.x * side)
    local y = (entity:getPositionY() + self.anchorPoint.y * side)
    return cc.rect(x + self.offset.x, y + self.offset.y, side, side)
end

function M:getCenterPos()
    local entity = self:getEntity()
    local x = (entity:getPositionX() - (0.5 - self.anchorPoint.x) * self.radius)
    local y = (entity:getPositionY() + (0.5 - self.anchorPoint.y) * self.radius)
    return cc.p(x + self.offset.x, y + self.offset.y)
end

-----
function M:_onClass(className,id)
    return className,id
end

function M:_onAdded(entity)
    local spriteComp = entity:getComponent("SpriteComponent")
    if spriteComp then
        local spriteSize = spriteComp:getContentSize()
        local radius = math.sqrt((spriteSize.width/2) * (spriteSize.width/2) + (spriteSize.height/2)*(spriteSize.height/2))
        self.radius = math.max(self.radius,radius)
    end
end

---
function M:_onCollide(collder)
    local otherType = collder._type
    if otherType == ColliderComponent.EColliderType.Rect then
        return cc.rectIntersectsRect(self:getInSideRect(),collder:getRect())
    elseif otherType == ColliderComponent.EColliderType.Circle then
        --圆心距小于等于半径和
        local distance = cc.pGetDistance(cc.pSub(self:getCenterPos(), collder:getCenterPos()))
        local radiusAdd = self.radius + collder.radius
        return(distance <= radiusAdd)

    end
    return false
end

return M