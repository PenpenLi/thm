
module("EntityUtil", package.seeall)
local EEntityType = GameDef.Stage.EEntityType

function code2Type(code)
    return math.floor((code / 100000) % 100),math.floor(code / 10000)
end

function type2Code(type,id)
    return tonumber(string.format("1%02d0%04d",type,id))
end

function newData(params)
    local code = params
    if type(params) == "table" then 
        code = params.code or params.cfgCode 
    else
        params = {code = params}
    end

    local type = code2Type(code)
    if type == EEntityType.Player then
        return StageDefine.PlayerEntityData.new(params)
    elseif type == EEntityType.Wingman then
        return StageDefine.WingmanEntityData.new(params)
    elseif type == EEntityType.Boss then
        return StageDefine.BossEntityData.new(params)
    elseif type == EEntityType.Batman then
        return StageDefine.BatmanEntityData.new(params)
    elseif type == EEntityType.PlayerBullet then
        return StageDefine.PlayerBulletEntityData.new(params)
    elseif type == EEntityType.EnemyBullet then
        return StageDefine.EnemyBulletEntityData.new(params)
    elseif type == EEntityType.WingmanBullet then
        return StageDefine.WingmanBulletEntityData.new(params)
    elseif type == EEntityType.Prop then
        return StageDefine.PropEntityData.new(params)
    end
end

---
function isBullet(entity)
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    if entityType == EEntityType.PlayerBullet or
        entityType == EEntityType.EnemyBullet or
        entityType == EEntityType.WingmanBullet
    then
        return true
    end
    return false
end

function isPlayer(entity)
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    if entityType == EEntityType.Player then
        return true
    end
    return false
end