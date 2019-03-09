local EEntityType = Const.Stage.EEntityType
local EEntityLayerType = Const.Stage.EEntityLayerType
module("EntityManager", package.seeall)

local objectPool = THSTG.UTIL.newObjectPool()
------
local function loadEntityClass(category,type)
    local class = StageConfig.getEntityClass(category,type)
    assert(class, string.format("[EntityManager] Class is not finded (%s,%s)!",category,type))
    return class
end

local function createObject(class,isReusable)
    local entity = nil
    if isReusable then
        entity = objectPool:create(class)
    else
        entity = class.new()
    end
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

    if params.action then
        local actionComp = entity:getComponent("ActionComponent")
        actionComp:runAction(params.action)
    end

    if params.isReusable then
        -- 防止二次添加
        -- 添加对象管理组件
        local poolMgr = entity:getScript("ManageByPool")
        if not poolMgr then 
            poolMgr = StageDefine.ManageByPool.new()
            poolMgr.poolMgr = objectPool
            entity:addScript(poolMgr)
        end
    end
    

    Dispatcher.dispatchEvent(EventType.STAGE_ADD_ENTITY,entity,layerType)
end

function createEntityObject(class,isReusable,layerType)
    local entity = createObject(class,isReusable)
    initEntity(entity,{
        isReusable = isReusable
    })

    return entity
end

function createEntity(category,type,isReusable,initPos,initSpeed,initAction)
    local class = loadEntityClass(category,type)
    if not class then return end

    local entity = createObject(class,isReusable)
    initEntity(entity,{
        pos = initPos,
        speed = initSpeed,
        action = initAction,
        isReusable = isReusable,
    })

    return entity
end

function createEntities(category,type,num,isReusable,initFunc)
    local class = loadEntityClass(category,type)
    if not class then return end

    for i = 1,num do
        local entity = createObject(class,isReusable)
        entity:setLocalZOrder(i)

        local initPos,initSpeed,initAction = initFunc(i,entity)
        initEntity(entity,{
            pos = initPos,
            speed = initSpeed,
            action = initAction,
            isReusable = isReusable,
        })
    end
end

---
function expandEntityObject(class,num)
    return objectPool:expand(class,num)
end

function expandEntity(category,type,num)
    local class = loadEntityClass(category,type)
    if not class then return end
    
    expandEntityObject(class,num)
end

function clearEntities()
    objectPool:clearAll()
end

--
function createEnemyBullet(type,initPos,initSpeed)
    return createEntity(EEntityType.EnemyBullet,type,true,initPos,initSpeed)
end

function createEnemyBullets(type,num,initFunc)
    return createEntities(EEntityType.EnemyBullet,type,num,true,initFunc)
end

function createBatman(type,initPos,initSpeed)
    return createEntity(EEntityType.Batman,type,true,initPos,initSpeed)
end

function createBatmans(type,num,initFunc)
    return createEntities(EEntityType.Batman,type,num,true,initFunc)
end

function createProp(type,initPos,initSpeed)
    return createEntity(EEntityType.Prop,type,true,initPos,initSpeed)
end

function createProps(type,num,initFunc)
    return createEntities(EEntityType.Prop,type,num,true,initFunc)
end
-----
--防止二次创建
function createBoss(type,initPos,initSpeed)
    return createEntity(EEntityType.Boss,type,false,initPos,initSpeed) 
end
function createPlayer(type,initPos,initSpeed)
    return createEntity(EEntityType.Player,type,false,initPos,initSpeed)
end