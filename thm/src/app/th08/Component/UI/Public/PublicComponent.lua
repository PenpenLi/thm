module("UIPublic", package.seeall)

function newRotateIcon(params)
    params = params or {}
    params.x = params.x or 0
    params.y = params.y or 0
    params.anchorPoint = params.anchorPoint or THSTG.UI.POINT_CENTER
    params.time = params.time or -1
    params.speed = params.speed or false
    params.source = params.source or ResManager.getRes(ResType.PUBLIC_UI,"loading_icon_1")
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
    local sheet = params.sheet 
    local image = THSTG.UI.newImage(params)

    function image:setSheetInfo(sheetKey)
        local info = SheetConfig.getRes(sheetKey)
        image:setSource(info.src)
        image:setTextureRect(info.rect)
        local size = cc.size(params.width or info.rect.width,params.height or info.rect.height)
        image:setContentSize(size)
    end

    image:setSheetInfo(sheet)

    return image
end

function newSheetSprite(params)
    local sheet = params.sheet 
    local sprite = THSTG.UI.newSprite(params)

    function sprite:setSheetInfo(sheetKey)
        local info = SheetConfig.getRes(sheetKey)
        sprite:setSource(info.src)
        sprite:setRect(info.rect)
        local size = cc.size(params.width or info.rect.width,params.height or info.rect.height)
        sprite:setContentSize(size)
    end
    

    sprite:setSheetInfo(sheet)

    return sprite
end