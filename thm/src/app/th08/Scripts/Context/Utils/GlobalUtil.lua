module("GlobalUtil", package.seeall)

function playEffect(params)
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

    local node = THSTG.UI.newSpineAnimation(params)

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

function playParticle(params)

    local node = THSTG.UI.newParticleSystem(params)

    if params.father then
        params.father:addChild(node)
    elseif params.refNode then
        node:setPositionX(params.refNode:getPositionX())
        node:setPositionY(params.refNode:getPositionY())
        node:setAnchorPoint(cc.p(0.5,0.5))
        params.refNode:getParent():addChild(node)
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


function playSEXParticle(params)
    params = params or {}
    if params.source then
        params.type = params.source[1]
        params.name = params.source[2]
    else
        params.type = params.type or EffectType.PUBLIC
    end
    
    return SEXManager.playParticle(params)
end