return {
    ["Idle"] = function (sprite,prevAction)
        local actions = {}
        if prevAction == "move_left" or prevAction == "move_right" then
            table.insert( actions,cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_move_left",1/30)):reverse())
            table.insert( actions,cc.CallFunc:create(function() 
                sprite:setFlippedX(not sprite:isFlippedX())
            end))
        end
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:playAnimationForever(AnimationCache.getResBySheet("player00","reimu_stand_normal"))
        end))

        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create(actions))
    end,

    ["MoveLeft"] = function (sprite,prevAction)
        sprite:setFlippedX(false)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(
                    cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_move_left_sustain"))
                ))
            end)
        }))
    end,

    ["MoveRight"] = function (sprite,prevAction)
        sprite:setFlippedX(true)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_move_left_start")),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(
                    cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_move_left_sustain"))
                ))
            end)
        }))
    end,
}