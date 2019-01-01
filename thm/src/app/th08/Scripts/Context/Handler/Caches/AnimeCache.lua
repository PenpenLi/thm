module("AnimeCache", package.seeall)

----
function play(params)
    params = params or {}
    params.layer = params.layer or params.refNode
    params.refNode = params.refNode
    params.onAction = params.onAction or function () end
    params.isLoop = params.isLoop

    local sprite = THSTG.SCENE.newSprite({
        x = params.refNode:getPositionX(),
        y = params.refNode:getPositionY(),
        anthorPoint = cc.p(0.5,0.5),
    })
    sprite:addTo(params.layer)
    local action = params.onAction(sprite)
    if params.isLoop == true then
        action = cc.Sequence:create(action)
    elseif params.isLoop == false then
        action = cc.RepeatForever:create(cc.Sequence:create(action))
    end

    sprite:runAction(action)
end
