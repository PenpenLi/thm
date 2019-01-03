module("EffectCache", package.seeall)

-- local _spriteCache = {}
----
function play(params)
    params = params or {}

    params.refNode = params.refNode
    params.onAction = params.onAction or function () end
    params.isLoop = params.isLoop

    params.offset = params.offset or cc.p(0,0)

    local layer = nil
    local posX = params.x or 0
    local posY = params.y or 0
    local aPoint = params.anchorPoint or cc.p(0.5,0.5)

    if params.father then
        layer = params.father
    elseif params.refNode then
        layer = params.refNode:getParent()
        posX = params.refNode:getPositionX()
        posY = params.refNode:getPositionY()
    end

    local sprite = THSTG.SCENE.newSprite({
        x = posX + params.offset.x,
        y = posY + params.offset.y,
        anchorPoint = aPoint,
    })

    if layer then
        layer:addChild(sprite) 
    end

    local action = params.onAction(sprite)
    if params.isLoop == false then
        local tmpAction = action
        table.insert(tmpAction, cc.CallFunc:create(function()
            sprite:removeFromParent()
        end))
        action = cc.Sequence:create(tmpAction)

    elseif params.isLoop == true then
        action = cc.RepeatForever:create(cc.Sequence:create(action))
    end

    sprite:runAction(action)

    return sprite
end
--
function clear()

end