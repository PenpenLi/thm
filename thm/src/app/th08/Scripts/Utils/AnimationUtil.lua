module("AnimationUtil", package.seeall)

function playMoveLeft()
    self.sprite:setFlippedX(false)
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create({
        cc.Animate:create(AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("move_left_start"))),
        cc.CallFunc:create(function() 
            self.sprite:runAction(cc.RepeatForever:create(
                cc.Animate:create(AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("move_left_sustain")))
            ))
        end)
    }))
end

function playMoveLeft()
    self.sprite:setFlippedX(true)
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create({
        cc.Animate:create(AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("move_left_start"))),
        cc.CallFunc:create(function() 
            self.sprite:runAction(cc.RepeatForever:create(
                cc.Animate:create(AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("move_left_sustain")))
            ))
        end)
    }))
end


function playIdle()
    local actions = {}
    if event.from == "MoveRight" or event.from == "MoveLeft" then
        local animation = AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("move_left"))
        animation:setDelayPerUnit(1/26)
        table.insert( actions,cc.Animate:create(animation):reverse())
        table.insert( actions,cc.CallFunc:create(function() 
            self.sprite:setFlippedX(not self.sprite:isFlippedX())
        end))
    end
    table.insert( actions,cc.CallFunc:create(function() 
        self.sprite:playAnimationForever(AnimationCache.getResBySheet(Cache.stageCache:getCurRoleAnimSheetArgs("stand_normal")))
    end))
    self.sprite:stopAllActions()
    self.sprite:runAction(cc.Sequence:create(actions))
end