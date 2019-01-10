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

function newSheetImage(params)
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

function newSheetSprite(params)
    local source = params.source
    local sprite = THSTG.UI.newSprite(params)

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