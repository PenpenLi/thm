local M = {}
setmetatable(M, {__index = THSTG.EffectServer})

local function newSEXNode(params)
    params = params or {}
    params.onAction = params.onAction or function () return {} end
    -----
    local sprite = THSTG.UI.newSprite({
        x = params.x or display.cx,
        y = params.y or display.cy,
        anchorPoint = params.anchorPoint or cc.p(0.5,0.5),
    })

    ----
    function sprite:play()
        local actions = params.onAction(self)
        local action = cc.Sequence:create(actions)
        self:runAction(action)
    end
    
    function sprite:playForever()
        local actions = params.onAction(self)
        local action = cc.RepeatForever:create(cc.Sequence:create(actions))
        self:runAction(action)
    end

    function sprite:stop()
        self:stopAllActions()
    end

    return sprite
end

--播放Action行为特效
function playSEXEffect(params)
    params = params or {}
    ----
    if params.source then
        params.isLoop = params.isLoop or false
        
        if params.isLoop == false then
            params.onAction = function (node)
                local actions = SEXFactory.getEffect(params.source[1])()
                table.insert( actions, cc.RemoveSelf:create())
                return actions
            end
        elseif params.isLoop == true then
            params.onAction = function (node)
                local actions = SEXFactory.getEffect(params.source[1])()
                table.insert( actions, cc.CallFunc:create(function () 
                    node:runAction(cc.RepeatForever:create(cc.Sequence:create(actions)))
                end))
                return actions
            end
            
        end
        
    end

    local node = newSEXNode(params)

    ---
    local layer = nil
    if params.father then
        layer = params.father
    elseif params.refNode then
        local posX = params.x or params.refNode:getPositionX()
        local posY = params.y or params.refNode:getPositionY()
        local aPoint = params.anchorPoint or cc.p(0.5,0.5)
       
        layer = params.refNode:getParent()
        node:setAnchorPoint(aPoint)
        node:setPosition(cc.p(posX,posY))
    end
    if layer then
        layer:addChild(node) 
    end
    ---
    node:play()

    return node
end

function playSEXParticle(params)
    params = params or {}
    local node = THSTG.EFFECT.newParticleSystem(params)

    if params.source then
        local info = SEXFactory.getParticle(params.source[1])()
        local tex,rect = nil,nil
        if info.texSrc then
            tex,rect = THSTG.SCEEN.loadTexture(info.texSrc)
        elseif info.tex then
            tex = info.tex
        end
        if info.texRect then
            rect = info.texRect
        end
        node:setTextureWithRect(tex,rect)
    end
    
    return node
end

----

return M