module(..., package.seeall)
--播放补间动画特效
function playTween(params)
    params = params or {}
    params.isLoop = params.isLoop or false
    params.isRemoveLate = params.isRemoveLate or (not params.isLoop)

    params.default = params.default or "stand"

    if params.isRemoveLate then
        local oldOnComplete = params.onComplete
        params.onComplete = function (sender)
            sender:runAction(cc.Sequence:create({
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(function ()
                    sender:removeFromParent()
                    if type(oldOnComplete) == "function" then 
                        oldOnComplete(sender)
                    end
                end),
            }))

        end
    end

    local node = THSTG.ANIMATION.newSpineAnimation(params)

    node:playAnimation(0,params.animation,params.isLoop)

    if params.father then
        params.father:addChild(node)
    elseif params.refNode then
        params.refNode:getParent():addChild(node)
    end

    
    if params.scale then
        node:setScale(params.scale)
    end

    return node
end

--播放骨骼动画
function playSkeleton(params)

end

--播放序列帧动画
function playSequence(params)
    
end