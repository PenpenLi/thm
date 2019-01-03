module(..., package.seeall)

function playEffect(params)
    
    if not params.onAction then
        params.isLoop = params.isLoop or false
        params.type = params.type or StageDefine.EffectType.PUBLIC
        local onAction = function(node)
            return StageDefine.ConfigReader.getEffect(params.type,params.name)()
        end
        params.onAction = onAction
    end

    return EffectCache.play(params)
end