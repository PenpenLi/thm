module("GlobalUtil", package.seeall)

function playEffect(params)
    params = params or {}
    params.isLoop = params.isLoop or false
    params.default = params.default or "stand"
    local node = THSTG.UI.newSkeletonAnimation(params)

    node:setAnimation(0,params.default,params.isLoop)

    if params.father then
        params.father:addChild(node)
    elseif params.refNode then
        params.refNode:getParent():addChild(node)
    end

    if not params.isLoop then
       
        node:registerSpineEventHandler(function (event) 
            --TODO:没起效???
            node:removeFromParent()
        end, sp.EventType.ANIMATION_COMPLETE)

    end

    if params.scale then
        node:setScale(params.scale)
    end

    return node
end

function playSFXEffect(params)
    if not params.onAction then
        params.isLoop = params.isLoop or false
        params.type = params.type or EffectType.PUBLIC
        local onAction = function(node)
            return ScriptManager.getSFXEffect(params.type,params.name)()
        end
        params.onAction = onAction
    end

    return SpriteCache.create(params)
end