local M = class("SpriteComponent",THSTG.ECS.Component)

function M:_onInit()
    self._sprite = THSTG.SCENE.newSprite()
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

---
function M:_onAdded(entity)
    self._sprite = self._sprite or THSTG.SCENE.newSprite()
    entity:addChild(self._sprite)
    self._sprite:setAnchorPoint(cc.p(0.5,0.5))
end

function M:_onRemoved(entity)
    self._sprite:removeFromParent()
    self._sprite = nil
end

function M:_onActive(val)
    self:_getSprite():setVisible(val)
end

--
function M:_getSprite()
    return self._sprite
end
return M