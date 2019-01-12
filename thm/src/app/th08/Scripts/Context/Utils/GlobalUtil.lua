module("GlobalUtil", package.seeall)

function playEffect(params)
    params = params or {}
    params.isLoop = params.isLoop or false
    params.default = params.default or "stand"
    if not params.isLoop and not params.onComplete then
        params.onComplete = function (sender)
            sender:runAction(cc.Sequence:create({
                cc.DelayTime:create(0.01),
                cc.RemoveSelf:create(),
            }))
        end
    end

    local node = THSTG.UI.newSkeletonAnimation(params)

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

function playSEXEffect(params)
    params = params or {}
    if params.source then
        params.type = params.source[1]
        params.name = params.source[2]
    else
        params.type = params.type or EffectType.PUBLIC
    end
    
    return SEXManager.playEffect(params)
end