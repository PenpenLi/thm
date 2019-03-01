local BaseEntity = require("Scripts.Context.Game.Modules.Test.GameTest.Misc.BaseEntity")
local M = class("Player",BaseEntity)
local EGameKeyType = Const.Public.EGameKeyType
local ETouchExType = THSTG.CONST.PUBLIC.ETouchExType
local EPlayerActionStatus = Const.Public.EPlayerActionStatus
function M:ctor()
    self.__rigidBodyRect = cc.rect(0,0,20,20)
    self:setAnchorPoint(THSTG.UI.POINT_CENTER)
    self:setContentSize(cc.size(self.__rigidBodyRect.width,self.__rigidBodyRect.height))
    
    self.__playerActionStatus = EPlayerActionStatus.Normal
    self.__mainSprite = THSTG.UI.newSprite()
    self.__mainSprite:playAnimationForever(AnimationCache.getResBySheet("reimu_stand_normal"))
    self.__mainSprite:setAnchorPoint(THSTG.UI.POINT_CENTER)
    self.__mainSprite:setContentSize(cc.size(self:getContentSize().width,self:getContentSize().height))
    self.__mainSprite:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))

    self:addChild(self.__mainSprite)

    debugUI(self)

    --
    self.__bullets = {} --缓存池
    self.__isStateWipe = false
    self.__tickClock = THSTG.UTIL.newTickClock()
    self.__isWipeEffectNode =  THSTG.UI.newNode({
        x = self:getContentSize().width/2,
        y = self:getContentSize().height/2,
        anchorPoint = THSTG.UI.POINT_CENTER,
        width = 80,
        height = 80,
    })
    self.__isWipeEffectNode:setVisible(false)
    self:addChild(self.__isWipeEffectNode)
    debugUI(self.__isWipeEffectNode)

    --
    self:onNodeEvent("enter", function ()
        self:scheduleUpdateWithPriorityLua(self.update,0)
    end)

    self:onNodeEvent("exit", function ()
        self:unscheduleUpdate()
    end)
end

function M:shot(node)   --FIXME:
    
    if self.__tickClock:getElpased() < 150 then
        return 
    end

    --生成/或从缓存池中取出3个精灵
    local function makeAction(node)
        local actions = {}
        table.insert( actions, cc.MoveBy:create(1.0,cc.p(0,display.height)))
        table.insert( actions,cc.CallFunc:create(function ()
            node:removeFromParent()
        end))
        
        return cc.Sequence:create(actions)
    end
    --FIXME:需要一个粒子系统
    local bullet = THSTG.UI.newNode({
        x = self:getPositionX(),
        y = self:getPositionY() + self:getContentSize().height + 10,
        anchorPoint = THSTG.UI.POINT_CENTER,
        width = 5,
        height = 5,
    })

    debugUI(bullet)
    bullet:runAction(makeAction(bullet))
    node:addChild(bullet)

    self.__tickClock:resume()
end

function M:setPos(dest)
    self:setPosition(dest)
end

function M:getPos()
    return self:getPosition()
end

function M:move(x,y)
    local oldX,oldY = self:getPos()
    local sprite = self.__mainSprite
    self:setPos(cc.p(oldX+x,oldY+y))
    if x  < 0 then
        if  self.__playerActionStatus == EPlayerActionStatus.MoveLeft then return end
        sprite:setFlippedX(false)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getResBySheet("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(AnimationCache.getResBySheet("reimu_move_left_sustain"))))
            end)
        }))
        self.__playerActionStatus = EPlayerActionStatus.MoveLeft
    elseif x  > 0 then
        if  self.__playerActionStatus == EPlayerActionStatus.MoveRight then return end
        sprite:setFlippedX(true)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getResBySheet("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(AnimationCache.getResBySheet("reimu_move_left_sustain"))))
            end)
        }))
        self.__playerActionStatus = EPlayerActionStatus.MoveRight
    else
        if  self.__playerActionStatus == EPlayerActionStatus.Normal then return end
        local actions = {}
        if self.__playerActionStatus == EPlayerActionStatus.MoveLeft or self.__playerActionStatus == EPlayerActionStatus.MoveRight then
            table.insert( actions,cc.Animate:create(AnimationCache.getResBySheet("reimu_move_left")):reverse())--
            table.insert( actions,cc.CallFunc:create(function() 
                sprite:setFlippedX(not sprite:isFlippedX())
            end))
        end
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:playAnimationForever(AnimationCache.getResBySheet("reimu_stand_normal"))
        end))

        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create(actions))

        self.__playerActionStatus = EPlayerActionStatus.Normal
    end
    
end

function M:skill()
    local function makeAction(node)
        local actions = {}
        node:setScale(0)
        table.insert(actions,cc.Spawn:create({
            cc.RotateBy:create(1.0, 360),
            cc.ScaleTo:create(1.0,1),
        }))
        table.insert(actions,cc.DelayTime:create(2.0))
        table.insert(actions,cc.Spawn:create({
            cc.RotateBy:create(1.0, -360),
            cc.ScaleTo:create(1.0,0),
        }))

        table.insert(actions,cc.CallFunc:create(function ()
            node:removeFromParent()
        end))
        
        return cc.Sequence:create(actions)
    end

    local effectNode = THSTG.UI.newNode({
        x = self:getContentSize().width/2,
        y = self:getContentSize().height/2,
        anchorPoint = THSTG.UI.POINT_CENTER,
        width = 80,
        height = 80,
    })
    debugUI(effectNode)
    effectNode:runAction(makeAction(effectNode))
    self:addChild(effectNode)
end

function M:wipeOpen()
    local function makeAction(node)
        local actions = {}
        node:setScale(0)
        node:setVisible(true)
        table.insert(actions,cc.Spawn:create({
            cc.RotateBy:create(1.0, 360),
            cc.ScaleTo:create(1.0,1),
        }))
      
        return cc.Sequence:create(actions)
    end

    self.__isWipeEffectNode:stopAllActions()
    self.__isWipeEffectNode:runAction(makeAction(self.__isWipeEffectNode))

end

function M:wipeClose()
    local function makeAction(node)
        local actions = {}
        table.insert(actions,cc.Spawn:create({
            cc.RotateBy:create(1.0, -360),
            cc.ScaleTo:create(1.0,0),
        }))

        table.insert(actions,cc.CallFunc:create(function ()
            self.__isWipeEffectNode:setVisible(false)

        end))
      
        return cc.Sequence:create(actions)
    end
    self.__isWipeEffectNode:stopAllActions()
    self.__isWipeEffectNode:runAction(makeAction(self.__isWipeEffectNode))

end


function M:wipe(state)
    if self.__isStateWipe ~= state then
        if state then 
            self:wipeOpen()
        else
            self:wipeClose()
        end
    end
    self.__isStateWipe = state
end

function M:update()
  
end

return M