local M = class("AnimationComponent",THSTG.ECS.Component)

function M:_onInit()
    self.sprite = THSTG.SCENE.newSprite()
end

function M:_onAdded(entity)
    entity:addChild(self.sprite)
end

function M:_onRemoved(entity)
    self.sprite:removeFromParent()
end


return M