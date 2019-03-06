local EEntityType = Const.Stage.EEntityType
module(..., package.seeall)
------
local function loadEntityClass(category,type)
    local class = StageConfig.getEntityClass(category,type)
    assert(class, string.format("[EntityManager] Class is not finded (%s,%s)!",category,type))
    return class
end

local function createObject(class)
    local entity = class.new()
    return entity
end

local function initEntity(entity,params)
    params = params or {}
    if params.pos then
        local transComp = entity:getComponent("TransformComponent")
        transComp:setPosition(params.pos)
    end

    if params.speed then
        local rigidComp = entity:getComponent("RigidbodyComponent")
        rigidComp:setSpeed(params.speed)
    end

    if params.layerType then
        --TODO:
    end
    ---
    --TODO:
    -- 添加对象管理组件
end

function createEntityObject(class,layerType)
    local entity = createObject(class)
    initEntity(entity,{
        layerType = layerType,
    })
    return entity
end

function createEntity(category,type,initPos,initSpeed)
    local class = loadEntityClass(category,type)
    if not class then return end

    local entity = createObject(class)
    initEntity(entity,{
        pos = initPos,
        speed = initSpeed,
    })
    return entity
end

function removeEntity(entity)
    entity:getScript("EntityController"):destroy()
end

function createEntities(category,type,num,initFunc)
    local class = loadEntityClass(category,type)
    if not class then return end

    for i = 1,num do
        local entity = createObject(class)
        entity:setLocalZOrder(i)

        local initPos,initSpeed = initFunc(i,entity)
        initEntity(entity,{
            pos = initPos,
            speed = initSpeed,
        })
        
    end
end
--
function createEnemyBullet(type,initPos,initSpeed)
    return createEntity(EEntityType.EnemyBullet,type,initPos,initSpeed)
end

function createEnemyBullets(type,num,initFunc)
    return createEntities(EEntityType.EnemyBullet,type,num,initFunc)
end

function createBatman(type,initPos,initSpeed)
    return createEntity(EEntityType.Batman,type,initPos,initSpeed)
end

function createBatmans(type,num,initFunc)
    return createEntities(EEntityType.Batman,type,num,initFunc)
end

function createProp(type,initPos,initSpeed)
    return createEntity(EEntityType.Prop,type,initPos,initSpeed)
end

function createProps(type,num,initFunc)
    return createEntities(EEntityType.Prop,type,num,initFunc)
end
--
function createBoss(type,initPos,initSpeed)
    return createEntity(EEntityType.Boss,type,initPos,initSpeed) 
end
