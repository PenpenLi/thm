return {
    [StageDefine.ActionType.STAND] = function (sprite)
        local actions = {}
        table.insert( actions,cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left")):reverse())
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:setFlippedX(not sprite:isFlippedX())
        end))
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:playAnimationForever(AnimationCache.getSheetRes("reimu_stand_normal"))
        end))

        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create(actions))
    end,

    [StageDefine.ActionType.MOVE_LEFT] = function (sprite)
        sprite:setFlippedX(false)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_sustain"))))
            end)
        }))
    end,

    [StageDefine.ActionType.MOVE_RIGHT] = function (sprite)
        sprite:setFlippedX(true)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_sustain"))))
            end)
        }))
    end,
}