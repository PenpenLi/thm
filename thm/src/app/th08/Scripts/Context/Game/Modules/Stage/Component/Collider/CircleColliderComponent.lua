local ColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.ColliderComponent")
local M = class("CircleColliderComponent",ColliderComponent)

function M:_onInit()
    M.super._onInit(self)
    self.radius = 8

    self._type = ColliderComponent.EColliderType.Circle
end

function M:getInSideRect()
    local pos = cc.p(self._transComp:getPosition())
    local x = (pos.x + (0.5-self.anchorPoint.x) * self.radius)+ self.offset.x
    local y = (pos.y + (0.5-self.anchorPoint.y) * self.radius)+ self.offset.y
    return cc.rect(x , y , self.radius, self.radius)
end

function M:getOutSideRect()
    local pos = cc.p(self._transComp:getPosition())
    local side = math.sqrt( 2 * self.radius * self.radius )
    local x = (pos.x + (0.5-self.anchorPoint.x) * side)+ self.offset.x
    local y = (pos.y + (0.5-self.anchorPoint.y) * side)+ self.offset.y
    return cc.rect(x , y , side, side)
end

function M:getCenterPos()
    local pos = cc.p(self._transComp:getPosition())
    local x = (pos.x + (0.5 - self.anchorPoint.x) * self.radius)+ self.offset.x
    local y = (pos.y + (0.5 - self.anchorPoint.y) * self.radius)+ self.offset.y
    return cc.p(x , y )
end

-----
function M:_onClass(className,id)
    return className,id
end

function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    
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