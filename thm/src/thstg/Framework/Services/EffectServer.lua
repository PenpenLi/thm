module(..., package.seeall)

--播放粒子特效
function playParticle(params)
    local node = THSTG.EFFECT.newParticleSystem(params)

    if params.father then
        params.father:addChild(node)
    elseif params.refNode then
        node:setPositionX(params.refNode:getPositionX())
        node:setPositionY(params.refNode:getPositionY())
        node:setAnchorPoint(cc.p(0.5,0.5))
        params.refNode:getParent():addChild(node)
    end
    if params.scale then
        node:setScale(params.scale)
    end
    
    node:play()
    
    return node
end

function playEffect(params)
    return AnimatioSystem.playTween(params)
end
--
function applyShader(node,params)
    return THSTG.NodeUtil.applyShader(node,params)
end

function applyAction(node,params)
    --生成一个格子作为载体
    local node = THSTG.EFFECT.newNodeGrid()



    if params.targetNode then

    end
end