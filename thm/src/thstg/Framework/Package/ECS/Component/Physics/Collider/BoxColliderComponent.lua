local ColliderComponent = require("thstg.Framework.Package.ECS.Component.Physics.Collider.ColliderComponent")
local M = class("BoxColliderComponent",ColliderComponent)
function M:_onInit()
    M.super._onInit(self)
    self.size = cc.size(16,16)  --最小碰撞矩形
    
    self._type = ColliderComponent.EColliderType.Rect
end

function M:getRect()
    local pos = cc.p(self._transComp:getPosition())
    local x = (pos.x + (0.5-self.anchorPoint.x) * self.size.width) + self.offset.x
    local y = (pos.y + (0.5-self.anchorPoint.y) * self.size.height) + self.offset.y

    return cc.rect(x , y , self.size.width, self.size.height)
end


-----
function M:_onClass(className,id)
    return className,id
end

function M:_onAdded(entity)
    M.super._onAdded(self,entity)

    local spriteComp = entity:getComponent("SpriteComponent")
    if spriteComp then
        local size = spriteComp:getContentSize()
        self.size.width = math.max(self.size.width,size.width)
        self.size.height = math.max(self.size.height,size.height)
    end


    if __DEBUG__ and __SHOW_COLLIDER_DEBUG__ then
        local testRect = THSTG.UI.newNode({
            x = ((0.5-self.anchorPoint.x) * self.size.width) + self.offset.x,
            y = ((0.5-self.anchorPoint.y) * self.size.height) + self.offset.y,
            width = self.size.width,
            height = self.size.height,
            anchorPoint = cc.p(0.5,0.5)
        })
        entity:addChild(testRect)
        debugUI(testRect)
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