return {
    [StageDefine.ActionType.PLAYER_STAND] = function (sprite,prevAction)
        local actions = {}
        if prevAction == StageDefine.ActionType.PLAYER_MOVE_LEFT or prevAction == StageDefine.ActionType.PLAYER_MOVE_RIGHT then
            table.insert( actions,cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left",1/30)):reverse())
            table.insert( actions,cc.CallFunc:create(function() 
                sprite:setFlippedX(not sprite:isFlippedX())
            end))
        end
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:playAnimationForever(AnimationCache.getSheetRes("reimu_stand_normal"))
        end))

        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create(actions))
    end,

    [StageDefine.ActionType.PLAYER_MOVE_LEFT] = function (sprite,prevAction)
        sprite:setFlippedX(false)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(
                    cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_sustain"))
                ))
            end)
        }))
    end,

    [StageDefine.ActionType.PLAYER_MOVE_RIGHT] = function (sprite,prevAction)
        sprite:setFlippedX(true)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(
                    cc.Animate:create(AnimationCache.getSheetRes("reimu_move_left_sustain"))
                ))
            end)
        }))
    end,
}