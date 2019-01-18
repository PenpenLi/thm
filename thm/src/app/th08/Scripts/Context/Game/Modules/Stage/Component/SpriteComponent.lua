local M = class("SpriteComponent",THSTG.ECS.Component)

function M:_onInit()
    self._sprite = THSTG.SCENE.newSprite()
end
---
function M:getSprite()
    return self._sprite
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
    self:getSprite():setVisible(val)
end

return M