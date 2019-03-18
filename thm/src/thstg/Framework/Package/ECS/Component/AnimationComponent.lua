local M = class("AnimationComponent",ECS.Component)

function M:_onInit()
    self._spriteComp = nil
    --

end
---
function M:getSprite()
    return self._spriteComp:_getSprite()
end

function M:play(action)
    self:getSprite():runAction(action)
end

function M:playForever(animation,params)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self:play(action)
end

function M:playOnce(animation,params)
    local action = cc.Animate:create(animation)
    self:play(action)
end

function M:stopAll()
    self:getSprite():stopAllActions()
end
---
function M:_onAdded(entity)
    self._spriteComp = entity:getComponent("SpriteComponent")
    if not self._spriteComp then
        self._spriteComp = ECS.SpriteComponent.new()
        entity:addComponent(self._spriteComp)
    end
end

function M:_onRemoved(entity)
    
end



return M