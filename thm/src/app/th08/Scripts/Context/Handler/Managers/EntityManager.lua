local EEntityType = GameDef.Stage.EEntityType
module("EntityManager", package.seeall)

local objectPool = THSTG.UTIL.newObjectPool()
------
local function _loadEntityClass(code)
    local class = EntityClassMapConfig.tryGetClass(code)
    assert(class, string.format("[EntityManager] Class is not finded (%s)!",code))
    return class
end

local function _initEntity(entity,params)
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

    if params.code then
        entity:getScript("EntityBasedata"):setData(EntityUtil.newData(params.code))
    end
end

local function _createEntity(code,isReusable)
    local class = _loadEntityClass(code)
    if not class then return end

    local entity = createObject(class,isReusable)
    _initEntity(entity,{
        isReusable = isReusable,
        code = code,
    })

    return entity
end

function createObject(class,isReusable)
    local entity = nil
    if isReusable then
        entity = objectPool:create(class)
    else
        entity = class.new()
    end
    return entity
end

function createEntityObject(class,isReusable)
    local entity = createObject(class,isReusable)
    _initEntity(entity,{
        isReusable = isReusable
    })

    return entity
end

function createEntity(a1,a2,a3)
    if a3 == nil then
        if a2 == nil then
            return _createEntity(a1,a2)
        else
            if type(a2) == "boolean" then
                return _createEntity(a1,a2)
            else
                local code = EntityUtil.type2Code(a1,a2)
                return _createEntity(code,a3)
            end
        end
    end
    local code = EntityUtil.type2Code(a1,a2)
    return _createEntity(code,a3)
end

function releaseEntity(entity)
    objectPool:release(entity)
end

---
function expandObject(class,num)
    return objectPool:expand(class,num)
end

function expandEntity(category,type,num)
    local code = category
    if num ~= nil then 
        code = EntityUtil.type2Code(category,type) 
    else
        num = type 
    end
        
    local class = _loadEntityClass(code)
    if not class then return end
    
    expandObject(class,num)
end

function clearEntities()
    objectPool:clearAll()
end

--
function createEnemyBullet(type)
    return createEntity(EEntityType.EnemyBullet,type,true)
end

function createBatman(type)
    return createEntity(EEntityType.Batman,type,true)
end

function createProp(type)
    return createEntity(EEntityType.Prop,type,true)
end

-----
--防止二次创建
function createBoss(type)
    return createEntity(EEntityType.Boss,type,false) 
end
function createPlayer(type)
    return createEntity(EEntityType.Player,type,false)
end
function createWingman(type)
    return createEntity(EEntityType.Wingman,type,false)
end

