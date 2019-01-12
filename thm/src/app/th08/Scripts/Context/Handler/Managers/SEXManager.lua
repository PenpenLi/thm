module("SEXManager", package.seeall)


local EFFECT_PATH_PATTERN = "Scripts.Configs.Handwork.SEX.Effect.Effect"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function createNode(params)
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

function getEffectDict() return getDictByFile(EFFECT_PATH_PATTERN) end
function getEffect(effectType,name) return getEffectDict()[effectType][name] end
function playEffect(params)
    if not params.onAction then
        params.isLoop = params.isLoop or false

        local onAction = function(node)
            return getEffect(params.type,params.name)()
        end
        params.onAction = onAction
    end

    return createNode(params)
end