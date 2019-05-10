
module("EntityUtil", package.seeall)
local EEntityType = GameDef.Stage.EEntityType

function code2Type(code)
    return math.floor((code / 100000) % 100),math.floor(code / 10000)
end

function type2Code(type,id)
    return tonumber(string.format("1%02d0%04d",type,id))
end

function getDatas(code)
    local type = code2Type(code)
    local entityData = {}
    local animData = AnimationConfig.getAllInfo(code)
    if type == EEntityType.Player then
        entityData = PlayerConfig.getAllInfo(code)
    elseif type == EEntityType.Wingman then
        entityData = WingmanConfig.getAllInfo(code)
    elseif type == EEntityType.Boss then
        entityData = BossConfig.getAllInfo(code)
    elseif type == EEntityType.Batman then
        entityData = BatmanConfig.getAllInfo(code)
    elseif type == EEntityType.PlayerBullet then
        entityData = PlayerBulletConfig.getAllInfo(code)
    elseif type == EEntityType.EnemyBullet then
        entityData = EnemyBulletConfig.getAllInfo(code)
    elseif type == EEntityType.WingmanBullet then
        entityData = {}
    elseif type == EEntityType.Prop then
        entityData = PropConfig.getAllInfo(code)
    end
    return entityData,animData
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