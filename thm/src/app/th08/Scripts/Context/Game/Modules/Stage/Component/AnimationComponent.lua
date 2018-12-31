local M = class("AnimationComponent",THSTG.ECS.Component)

function M:_onInit()
    self.sprite = THSTG.SCENE.newSprite()
    self.state = false
end
---
function play(action)
    self.sprite:runAction(action)
end

function playForever(animation,params)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self:play(action)
end

function playOnce(animation,params)
    local action = cc.Animate:create(animation)
    self:play(action)
end
---
function M:_onAdded(entity)
    self.sprite = self.sprite or THSTG.SCENE.newSprite()
    entity:addChild(self.sprite)
end

function M:_onRemoved(entity)
    self.sprite:removeFromParent()
    self.sprite = nil
end



return M