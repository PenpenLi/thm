-- module(..., package.seeall)
PHYSICSSCENE_DEFAULT_PARAMS = {
    isHaveEdge = false,
    edgeParams = {
        x = display.cx , 
        y = display.cy ,
        body = PHYSICS.newEdgeBox({
            size = cc.size(display.width,display.height)
        }),
    },
    gravity = cc.vertex2F(0, -100),
    drawMask = false,
}

function newPhysicsScene(params)
    params = params or {}

    local scene = cc.Scene:createWithPhysics()

    local finalParams = clone(PHYSICSSCENE_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    if finalParams.isHaveEdge then 
        local edgeBody = finalParams.edgeParams.body
        local edgeNode = cc.Node:create()
        scene:addChild(edgeNode)
        edgeNode:setPosition(cc.p(finalParams.edgeParams.x ,finalParams.edgeParams.y))
        edgeNode:setPhysicsBody(edgeBody)
    end

    if finalParams.drawMask then --cc.PhysicsWorld.DEBUGDRAW_ALL
        scene:getPhysicsWorld():setDebugDrawMask(finalParams.drawMask)
    end

    if finalParams.gravity then 
        scene:getPhysicsWorld():setGravity(finalParams.gravity)
    end

    return scene
end