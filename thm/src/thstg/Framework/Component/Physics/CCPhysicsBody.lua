-- module(..., package.seeall)

PHYSICXBODY_CIRCLE_DEFAULT_PARAMS = {
    radius = 1,
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    offset = cc.p(0,0),
}

PHYSICXBODY_BOX_DEFAULT_PARAMS = {
    size = cc.size(1,1),
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    offset = cc.p(0,0),
}

PHYSICXBODY_POLYGON_DEFAULT_PARAMS = {
    points = {},
    count = 0,
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    offset = cc.p(0,0),
}

PHYSICXBODY_EDGESEGMENT_DEFAULT_PARAMS = {
    a = cc.p(0,0),
    b = cc.p(0,0),
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    border = 1,
}

PHYSICXBODY_EDGEBOX_DEFAULT_PARAMS = {
    size = cc.size(1,1),
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    border = 1,
    offset = cc.p(0,0),
}

PHYSICXBODY_EDGEPOLYGON_DEFAULT_PARAMS = {
    points = {},
    count = 0,
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    border = 1,
}

PHYSICXBODY_EDGECHAIN_DEFAULT_PARAMS = {
    points = {},
    count = 0,
    material = cc.PHYSICSBODY_MATERIAL_DEFAULT,
    border = 1,
}

function newCircle(params)
    params = params or {}

    local finalParams = clone(PHYSICXBODY_CIRCLE_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    return cc.PhysicsBody:createBox(
        finalParams.radius, 
        finalParams.material, 
        finalParams.offset)
end

function newBox(params)
    params = params or {}

    local finalParams = clone(PHYSICXBODY_BOX_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    return cc.PhysicsBody:createBox(
        finalParams.size, 
        finalParams.material, 
        finalParams.offset)
end

function newPolygon(params)
    params = params or {}

    local finalParams = clone(PHYSICXBODY_POLYGON_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    local count = #finalParams.points

    return cc.PhysicsBody:createPolygon(
        finalParams.points, 
        finalParams.count,
        finalParams.material, 
        finalParams.offset)
end

function newEdgeSegment(params)
    params = params or {}

    local finalParams = clone(PHYSICXBODY_EDGESEGMENT_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    local count = #finalParams.points

    return cc.PhysicsBody:createEdgeSegment(
        finalParams.a, 
        finalParams.b,
        finalParams.material, 
        finalParams.border)
end

function newEdgeBox(params)
    params = params or {}
   
    local finalParams = clone(PHYSICXBODY_EDGEBOX_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    return cc.PhysicsBody:createEdgeBox(
            finalParams.size, 
            finalParams.material, 
            finalParams.border,
            finalParams.offset)
end

function newEdgePolygon(params)
    params = params or {}
   
    local finalParams = clone(PHYSICXBODY_EDGEPOLYGON_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    return cc.PhysicsBody:createEdgePolygon(
        finalParams.points, 
        finalParams.count,
        finalParams.material, 
        finalParams.border)
end

function newEdgeChain(params)
    params = params or {}
   
    local finalParams = clone(PHYSICXBODY_EDGECHAIN_DEFAULT_PARAMS)
    TableUtil.mergeA2B(params, finalParams)

    return cc.PhysicsBody:createEdgeChain(
        finalParams.points, 
        finalParams.count,
        finalParams.material, 
        finalParams.border)
end