module("UIPublic", package.seeall)

function newRotateIcon(params)
    params = params or {}
    params.x = params.x or 0
    params.y = params.y or 0
    params.anchorPoint = params.anchorPoint or THSTG.UI.POINT_CENTER
    params.time = params.time or -1
    params.speed = params.speed or false
    params.source = params.source or ResManager.getRes(ResType.LOADING,"loading_icon_1")
    -----
    local node = THSTG.UI.newNode({
        x = params.x,
        y = params.y,
        anchorPoint = params.anchorPoint,
    })
    local icon = THSTG.UI.newImage({
        x = node:getContentSize().width/2,
        y = node:getContentSize().height/2,
        anchorPoint = THSTG.UI.POINT_CENTER,
        source = params.source
    })
    node:addChild(icon)

    function node.updateLayer()
        if params.time <0 then
            icon:runAction(cc.RepeatForever:create(
                cc.RotateBy:create(1,params.speed)
            ))
        else
            icon:runAction(cc.RotateBy:create(params.time,params.time*params.speed))
        end
    end

    node:onNodeEvent("enter", function ()
        node.updateLayer()
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    return node
end

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
   
    finalParams.width = nil
    finalParams.height = nil
    local sprite = THSTG.UI.newSprite(finalParams)

    function sprite:setSheetInfo(fileName,name)
        local info = SheetConfig.getFrame(fileName,name)
        sprite:setSource(info.source)
        sprite:setTextureRect(info.rect)
        local size = cc.size(params.width or info.rect.width,params.height or info.rect.height)
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

    local sprite = THSTG.UI.newSequenceAnimation(params)

    return sprite
end

----------------
-----------------
local function createUVSpriteByType(type,params)
    params = params or {}

    params.uRange = params.uRange or cc.p(0,1)
    params.vRange = params.vRange or cc.p(0,1)
    params.speed = params.speed or cc.p(1,1)

    local sprite = nil
    if type == 0 then
        sprite = THSTG.UI.newSprite(params)
    elseif type == 1 then
        sprite = newSheetFrameSprite(params)
    end

    local vsStr,fsStr = ShaderConfig.getShader("Uv_Sprite_Shader")
    THSTG.NodeUtil.applyShader(sprite,{
        shaderKey = "Uv_Sprite_Shader",
        vsStr = vsStr,
        fsStr = fsStr,
        onState = function (node,state)
            state:setUniformVec2("uRange",cc.vec3(params.uRange.x,params.uRange.y,0))
            state:setUniformVec2("vRange",cc.vec3(params.vRange.x,params.vRange.y,0))
            local count = cc.p(0,0)
            node:runAction(cc.RepeatForever:create(cc.Sequence:create({
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(function ()
                    count.x = count.x + params.speed.x/1000
                    count.y = count.y + params.speed.y/1000
                    state:setUniformVec2("texOffset",cc.vec3(count.x,count.y,0))
                end)
            })))
        end,
    })
    --
    function sprite:setSpeed(val)
        params.speed = val
    end
    function sprite:getSpeed(val)
        return params.speed
    end

    return sprite
end

function newUVSprite(params)
    local sprite = createUVSpriteByType(0,params)
    return sprite
end

function newUVSheetFrameSprite(params)
    local sprite = createUVSpriteByType(1,params)
    return sprite
end