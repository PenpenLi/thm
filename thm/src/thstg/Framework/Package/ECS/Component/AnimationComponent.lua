local M = class("AnimationComponent",ECS.Component)

function M:_onInit()
    self._spriteComp = nil
    --
    self._curAction = false
end
---
function M:_getSprite()
    return self:getSpriteComponent():_getSprite()
end
function M:getSpriteComponent()
    return self._spriteComp
end
----
function M:addAnimation(name,animation)
    self._animations = self._animations or {}
    self._animations[name] = animation
end

function M:getAnimation(name)
    return self._animations and self._animations[name]
end

function M:getAnimae(name)
    local animation = self:getAnimation(name)
    if animation then
        return cc.Animate:create(animation)
    end
    return nil
end

function M:removeAnimation(name)
    if self._animations then
        local animation = self._animations[name]
        if self._curAction == animation then
            self:stop()
        end
        self._animations[name] = nil
    end
end

function M:playOnce(name,callback)
    if self._animations then
        local animation = self._animations[name]
        if animation then
            local anime = cc.Animate:create(animation)
            self._curAction = cc.RepeatForever:create(anime)
            self:_getSprite():runAction(self._curAction)
            return self._curAction
        end
    end
end

function M:playForever(name)
    if self._animations then
        local animation = self._animations[name]
        if animation then
            self._curAction = cc.Animate:create(animation)
            self:_getSprite():runAction(self._curAction)
            return self._curAction
        end
    end
end

function M:playCustom(action)
    self:_getSprite():runAction(action)
    self._curAction = action
end

function M:stop()
    self:_getSprite():stopAllActions()
    self._curAction = false

    -- if self._curAction then
    --     if not tolua.isnull(self._curAction) then
    --         self:_getSprite():stopAction(self._curAction)
    --     end
    --     self._curAction = false
    -- end
end

-- -----
-- function M:play(action)
--     self:_getSprite():runAction(action)
-- end

-- function M:playForever(animation,params)
--     local action = cc.RepeatForever:create(cc.Animate:create(animation))
--     self:play(action)
-- end

-- function M:playOnce(animation,params)
--     local action = cc.Animate:create(animation)
--     self:play(action)
-- end

-- function M:stopAll()
--     self:_getSprite():stopAllActions()
-- end
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