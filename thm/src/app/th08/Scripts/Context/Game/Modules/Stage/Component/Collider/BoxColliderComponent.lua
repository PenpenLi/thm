local ColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.ColliderComponent")
local M = class("BoxColliderComponent",ColliderComponent)
function M:_onInit()
    M.super._onInit(self)
    self.size = cc.size(16,16)  --最小碰撞矩形

    self._type = ColliderComponent.EColliderType.Rect
end

function M:getRect()
    local entity = self:getEntity()
    local x = (entity:getPositionX() - self.anchorPoint.x * self.size.width)
    local y = (entity:getPositionY() + self.anchorPoint.y * self.size.height)
    return cc.rect(x + self.offset.x, y + self.offset.y, self.size.width, self.size.height)
end


-----
function M:_onClass(className,id)
    return className,id
end

function M:_onAdded(entity)
    local spriteComp = entity:getComponent("SpriteComponent")
    if spriteComp then
        local size = spriteComp:getContentSize()
        self.size.width = math.max(self.size.width,size.width)
        self.size.height = math.max(self.size.height,size.height)
    end
end

----
function M:_onCollide(collder)
    
    local otherType = collder._type
    if otherType == ColliderComponent.EColliderType.Rect then
        return cc.rectIntersectsRect(self:getRect(),collder:getRect())
    elseif otherType == ColliderComponent.EColliderType.Circle then
        return cc.rectIntersectsRect(self:getRect(),collder:getOutSideRect())
    end
    return false
end

return M