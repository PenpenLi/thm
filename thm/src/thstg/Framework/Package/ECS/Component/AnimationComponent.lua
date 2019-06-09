local M = class("AnimationComponent",ECS.Component)

function M:_onInit()
    self._spriteComp = nil
    --
    self._curAction = false
    self._animations = false
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
    animation:retain()
end

function M:getAnimation(name)
    return self._animations and self._animations[name]
end

function M:getAllAnimations()
    return self._animations
end

function M:removeAnimation(name)
    if self._animations then
        local animation = self._animations[name]
        if self._curAction == animation then
            self:stop()
        end
        self._animations[name] = nil
        animation:release()
    end
end

function M:removeAllAnimations()
    if self._animations then
        for _,v in pairs(self._animations) do
            v:release()
        end
        self._animations = false
    end
end

--list = item{name,startIndex,endIndex,count,speed,callback}
function M:playTimes(list,times)
    if type(list) == "string" then
        local newList = {}
        table.insert(newList, {list,false,false,false,false,false})
        list = newList
    end

    if type(list) == "table" then
        local actions = {}
        for _,v in ipairs(list) do
            local infoTb = v
            if type(v) == "string" then
                infoTb = {v}
            end
            local actionName = infoTb[1] or false
            local callback = infoTb[6] or false
            if actionName then
                local animation = self:getAnimation(actionName) or false
                if animation then
                    local startIndex = infoTb[2] or false
                    local endIndex = infoTb[3] or -1
                    local count = infoTb[4] or 1
                    local speed = infoTb[5] or false
                    
                    local newAnimation = animation
                    if type(startIndex) == "number" then
                        local frames = animation:getFrames()
                        if endIndex == -1 then endIndex = #frames end
                        local length = endIndex - startIndex
                        if length > 0 then
                            local frameArray = {}
                            local time = 1/math.abs(speed) or animation:getDelayPerUnit()
                            for i = startIndex, (startIndex + length) do
                                table.insert(frameArray,frames[i]:getSpriteFrame())
                            end
                            newAnimation = display.newAnimation(frameArray, time)
                        end
                    end

                    if count < 0 then
                        table.insert(actions, cc.CallFunc:create(function()
                            local anime = cc.Animate:create(newAnimation)
                            if type(speed) == "number" then
                                if speed < 0 then
                                    anime = anime:reverse()
                                end
                            end
                            self._curAction = cc.RepeatForever:create(anime)
                            self:_getSprite():runAction(self._curAction)
                        end))
                        break
                    elseif count > 0 then
                        local anime = cc.Animate:create(newAnimation)
                        if type(speed) == "number" then
                            if speed < 0 then
                                anime = anime:reverse()
                            end
                        end
                        for i = 1, count do table.insert(actions, anime) end
                    end
                end
            end
            if type(callback) == "function" then table.insert(actions, cc.CallFunc:create(callback)) end
        end
        
        if #actions > 0 then 
            if times < 0 then
                self._curAction = cc.RepeatForever:create(cc.Sequence:create(actions))
                self:_getSprite():runAction(self._curAction)
                return self._curAction
            elseif times > 0 then
                local array = {}
                for i = 1,times do table.insert(array, cc.Sequence:create(actions)) end
                self._curAction = cc.Sequence:create(array)
                self:_getSprite():runAction(self._curAction)
                return self._curAction
            end
        end
    end
end

function M:playOnce(list)
    return self:playTimes(list,1)
end

function M:playForever(list)
    return self:playTimes(list,-1)
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

function M:_onAdded(entity)
    self._spriteComp = entity:getComponent("SpriteComponent")
    if not self._spriteComp then
        self._spriteComp = ECS.SpriteComponent.new()
        entity:addComponent(self._spriteComp)
    end
end

function M:_onRemoved(entity)
    self:removeAllAnimations()
end

return M