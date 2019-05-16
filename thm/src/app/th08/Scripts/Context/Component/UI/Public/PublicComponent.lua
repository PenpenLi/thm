module("UIPublic", package.seeall)

function newSheetFrameImage(params)
    local source = params.source
    local image = THSTG.UI.newImage(params)

    function image:setSheetInfo(fileName,name)
        local info = SheetConfig.getFrame(fileName,name)
        image:setSource(info.source)
        image:setTextureRect(info.rect)
        local size = cc.size(params.width or info.rect.width,params.height or info.rect.height)
        image:setContentSize(size)
    end

    image:setSheetInfo(source[1],source[2])

    return image
end

function newSheetFrameSprite(params)
    local finalParams = clone(params)
    local source = params.source
   
    local paramsWidth = params.width
    local paramsHeight = params.height
    params.width = nil
    params.height = nil
    local sprite = THSTG.UI.newSprite(params)

    function sprite:setSheetInfo(fileName,name)
        local info = SheetConfig.getFrame(fileName,name)
        sprite:setSource(info.source)
        sprite:setTextureRect(info.rect)
        local size = cc.size(paramsWidth or info.rect.width,paramsHeight or info.rect.height)
        sprite:setContentSize(size)
    end
    

    sprite:setSheetInfo(source[1],source[2])

    return sprite
end

function newSheetAnimationSprite(params)
    params = params or {}
    params.source = params.source or {}
    params.time = params.time or 1/12
    ---
    local info = SheetConfig.getSequence(params.source[1],params.source[2])
    local animation = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = info.source,
            length = info.length,
            rect = info.rect,
        }),
        time = params.time
    })
    params.animation = animation

    local sprite = THSTG.ANIMATION.newSpineAnimation(params)

    return sprite
end

----------------
-----------------
function newSprite(params)
    params = params or {}
    --

    local paramsWidth = params.width
    local paramsHeight = params.height
    if type(params.source) == "string" then params.src = params.src or params.source end
    local sprite = THSTG.UI.newSprite(params)

    function sprite:setSheetInfo(fileName,name)
        local info = SheetConfig.getFrame(fileName,name)
        sprite:setSource(info.source)
        sprite:setTextureRect(info.rect)
        
        sprite:setContentSize(cc.size(info.rect.width,info.rect.height))
    end

    if type(params.source) == "table" then
        if params.source[1] == TexType.SHEET then
            sprite:setSheetInfo(params.source[2],params.source[3])
            --根据宽高变形
            local size = sprite:getContentSize()
            sprite:setScale(1)
            if paramsWidth then sprite:setScaleX(paramsWidth / size.width) end
            if paramsHeight then sprite:setScaleY(paramsHeight / size.height) end
        end
    end

    if params.isTile then
        sprite:setScale(1)
        local size = sprite:getContentSize()
        sprite:getTexture():setTexParameters(gl.LINEAR,gl.LINEAR,gl.REPEAT,gl.REPEAT)
        sprite:setTextureRect(cc.rect(0, 0, paramsWidth or size.width, paramsHeight or size.height))
    end
    
    return sprite
end

function newShaderSprite(params)
    local sprite = newSprite(params)
    ---
    function sprite:setShaderEnabled(val)
        if val then
            if not params.shaderKey then return end
            THSTG.NodeUtil.applyShader(sprite,{
                shaderKey = params.shaderKey,
                vsSrc = params.vsSrc,
                fsSrc = params.fsSrc,
                onState = params.onState,
            })
        else
            THSTG.NodeUtil.applyShader(sprite)
        end
    end
    --
    if params.shaderKey then
        sprite:setShaderEnabled(true)
    end

    return sprite
end

local function newUVShaderSprite(params)
    local sprite = newShaderSprite(params)
    --
    local oldSetShaderEnabled = sprite.setShaderEnabled
    function sprite:setShaderEnabled(val)
        oldSetShaderEnabled(self,val)
    end
    return sprite
end

function newUVRollSprite(params)
    params = params or {}
    params.uniforms = params.uniforms or {}
    params.uniforms.uRange = params.uniforms.uRange or cc.p(0,1)
    params.uniforms.vRange = params.uniforms.vRange or cc.p(0,1)
    params.uniforms.speedX = params.uniforms.speedX or 1
    params.uniforms.speedY = params.uniforms.speedY or 1

    params.shaderKey = "Uv_Rolling_Sprite_Shader"
    params.onState = function (node,state)
        state:setUniformVec2("_uRange",cc.vec3(params.uniforms.uRange.x,params.uniforms.uRange.y,0))
        state:setUniformVec2("_vRange",cc.vec3(params.uniforms.vRange.x,params.uniforms.vRange.y,0))
        state:setUniformFloat("_speedX",params.uniforms.speedX)
        state:setUniformFloat("_speedY",params.uniforms.speedY)
    end
    local sprite = newUVShaderSprite(params)
    
    --

    function sprite:setSpeed(x,y)
        params.uniforms.speedX = x or params.uniforms.speedX
        params.uniforms.speedY = y or params.uniforms.speedY
    end
    function sprite:getSpeed(val)
        return params.uniforms.speedX,params.uniforms.speedY
    end

    return sprite
end

function newUVWaveSprite(params)
    params = params or {}
    params.uniforms = params.uniforms or {}
    params.uniforms.speed = params.uniforms.speed or 1.0
    params.uniforms.scale = params.uniforms.scale or 3.0
    params.uniforms.identity = params.uniforms.identity or 80.0

    --
    params.shaderKey = "Uv_Wave_Sprite_Shader"
    params.onState = function(node,state)
        state:setUniformFloat("_speed",params.uniforms.speed)
        state:setUniformFloat("_scale",params.uniforms.scale)
        state:setUniformFloat("_identity",params.uniforms.identity)
    end
    
    local node = newUVShaderSprite(params)
    return node
end

function newUVRippleSprite(params)
    params = params or {}
    params.uniforms = params.uniforms or {}
    params.uniforms.speed = params.uniforms.speed or 1.0
    params.uniforms.ripple = params.uniforms.ripple or 60.0
    params.uniforms.swing = params.uniforms.swing or 1.0

    
    --
    params.shaderKey = "Uv_Ripple_Sprite_Shader"
    params.onState = function(node,state)
        state:setUniformFloat("_speed",params.uniforms.speed)
        state:setUniformFloat("_ripple",params.uniforms.ripple)
        state:setUniformFloat("_swing",params.uniforms.swing)

    end
    
    local node = newUVShaderSprite(params)
    return node
end

function newGreySprite(params)
    params.shaderKey = "Grey_Sprite_Shader"
    --
    local node = newUVShaderSprite(params)
    
    function node:setDiscolored(val)
       self:setShaderEnabled(val)
    end

    node:setDiscolored(true)
    return node
end
