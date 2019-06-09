local EEntityType = GameDef.Stage.EEntityType
local M = {}

local objectPool = THSTG.UTIL.newObjectPool()
------
local function _loadEntityClass(code)
    local class = EntityClassMapConfig.tryGetClass(code)
    assert(class, string.format("[StageDefine.StageEntityManager] Class is not finded (%s)!",code))
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

    local entity = M.createObject(class,isReusable)
    _initEntity(entity,{
        isReusable = isReusable,
        code = code,
    })

    return entity
end

function M.createObject(class,isReusable)
    local entity = nil
    if isReusable then
        entity = objectPool:create(class)
    else
        entity = class.new()
    end
    return entity
end

function M.createEntityObject(class,isReusable)
    local entity = M.createObject(class,isReusable)
    _initEntity(entity,{
        isReusable = isReusable
    })

    return entity
end

function M.createEntity(a1,a2,a3)
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

function M.releaseEntity(entity)
    objectPool:release(entity)
end

---
function M.expandObject(class,num)
    return objectPool:expand(class,num)
end

function M.expandEntity(category,type,num)
    local code = category
    if num ~= nil then 
        code = EntityUtil.type2Code(category,type) 
    else
        num = type 
    end
        
    local class = _loadEntityClass(code)
    if not class then return end
    
    M.expandObject(class,num)
end

function M.clearEntities()
    objectPool:clearAll()
end

--
function M.createEnemyBullet(type)
    return M.createEntity(EEntityType.EnemyBullet,type,true)
end

function M.createBatman(type)
    return M.createEntity(EEntityType.Batman,type,true)
end

function M.createProp(type)
    return M.createEntity(EEntityType.Prop,type,true)
end

-----
--防止二次创建
function M.createBoss(type)
    return M.createEntity(EEntityType.Boss,type,false) 
end
function M.createPlayer(type)
    return M.createEntity(EEntityType.Player,type,false)
end
function M.createWingman(type)
    return M.createEntity(EEntityType.Wingman,type,false)
end


return M