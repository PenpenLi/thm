local M = class("PlayerAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

function M:_onSetup()
    return {
        initial = "Idle",
        events  = {
            {name = "MoveLeft",  from = {"Idle","MoveRight"},  to = "MoveLeft"},
            {name = "MoveRight",  from = {"Idle","MoveLeft"},  to = "MoveRight"},

            {name = "Idle", from = "*",  to = "Idle"},
        },
        callbacks = {
            onMoveLeft = handler(self,self._onMoveLeft),
            onMoveRight = handler(self,self._onMoveRight),
            onIdle = handler(self,self._onIdle),
        },
    }
end

----

function M:_onMoveLeft(event)
    self.sprite:setFlippedX(false)
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create({
        cc.Animate:create(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("move_left_start"))),
        cc.CallFunc:create(function() 
            self.sprite:runAction(cc.RepeatForever:create(
                cc.Animate:create(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("move_left_sustain")))
            ))
        end)
    }))
end

function M:_onMoveRight(event)
    self.sprite:setFlippedX(true)
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create({
        cc.Animate:create(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("move_left_start"))),
        cc.CallFunc:create(function() 
            self.sprite:runAction(cc.RepeatForever:create(
                cc.Animate:create(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("move_left_sustain")))
            ))
        end)
    }))
end


function M:_onIdle(event)
    local actions = {}
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        table.insert( actions,cc.Animate:create(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("move_left"))):reverse())
        table.insert( actions,cc.CallFunc:create(function() 
            self.sprite:setFlippedX(not self.sprite:isFlippedX())
        end))
    end
    table.insert( actions,cc.CallFunc:create(function() 
        self.sprite:playAnimationForever(AnimationCache.getResBySheet(Cache.roleCache.getCurAnimSheetByName("stand_normal")))
    end))
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create(actions))
end

----


return M