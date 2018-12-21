local M = class("AnimationComponent",THSTG.ECS.Component)

function M:_onInit()
    self.sprite = THSTG.SCENE.newSprite()

end
---
function play(action)
    
end

function playForever(action)

end

function playOnce(action)

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