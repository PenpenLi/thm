module(..., package.seeall)

function playEffect(params)
    
    if not params.onAction then
        params.isLoop = params.isLoop or false
        params.type = params.type or EffectType.PUBLIC
        local onAction = function(node)
            return TmplManager.getEffect(params.type,params.name)()
        end
        params.onAction = onAction
    end

    return SpriteCache.create(params)
end