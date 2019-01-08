local M = class("AnimationComponent",THSTG.ECS.Component)

function M:_onInit()
    self.spriteComp = nil
    --

end
---
function M:play(action)
    self.spriteComp:getSprite():runAction(action)
end

function M:playForever(animation,params)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self:play(action)
end

function M:playOnce(animation,params)
    local action = cc.Animate:create(animation)
    self:play(action)
end

function M:stop()
    self.spriteComp:getSprite():stopAllActions()
end
---
function M:_onAdded(entity)
    local spriteComp = entity:getComponent("SpriteComponent")
    assert(spriteComp, string.format("[%s] You must have a SpriteComponent ",M.__cname))
    self.spriteComp = spriteComp

 
end

function M:_onRemoved(entity)
    
end



return M