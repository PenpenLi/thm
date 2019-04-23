local M = class("SpriteComponent",ECS.Component)

function M:_onInit()
    self._sprite = SCENE.newSprite()
end
---


function M:getContentSize()
    return self:_getSprite():getContentSize()
end

function M:setContentSize(size)
    return self:_getSprite():setContentSize(size)
end

function M:setAnchorPoint(pt)
    return self:_getSprite():setAnchorPoint(pt)
end

function M:setRotation(val)
    return self:_getSprite():setRotation(val)
end

function M:setScale(val)
    return self:_getSprite():setScale(val)
end

function M:getScale(val)
    return self:_getSprite():getScale()
end

function M:setFlippedX(val)
    return self:_getSprite():setFlippedX(val)
end

function M:isFlippedX()
    return self:_getSprite():isFlippedX()
end

function M:setFlippedY(val)
    return self:_getSprite():setFlippedY(val)
end

function M:isFlippedY()
    return self:_getSprite():isFlippedY()
end

function M:setVisible(val)
    return self:_getSprite():setVisible(val)
end
function M:isVisible()
    return self:_getSprite():isVisible()
end

---
function M:_onAdded(entity)
    self._sprite = self._sprite or SCENE.newSprite()
    entity:addChild(self._sprite)
    self._sprite:setAnchorPoint(cc.p(0.5,0.5))
end

function M:_onRemoved(entity)
    self._sprite:removeFromParent()
    self._sprite = nil
end

--
function M:_getSprite()
    return self._sprite
end
return M