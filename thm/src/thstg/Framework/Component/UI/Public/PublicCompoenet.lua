module("UIPublic", package.seeall)

function newShaderSprite(params)
    params = params or {}
    local _isEnabled = true
    local sprite = newSprite(params)
    NodeUtil.applyShader(sprite,params)
    ---
    function sprite:setShaderEnabled(isEnabled)
        if isEnabled then
            NodeUtil.applyShader(self,params)
        else
            NodeUtil.applyShader(self)
        end
        _isEnabled = isEnabled
    end
    function sprite:isShaderEnabled()
        return _isEnabled
    end
    return sprite
end
