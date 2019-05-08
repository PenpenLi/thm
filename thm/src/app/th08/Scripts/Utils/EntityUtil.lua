
module("EntityUtil", package.seeall)
local EEntityType = GameDef.Stage.EEntityType

function code2Type(code)
    return math.floor((code / 100000) % 100)
end

function getRealData(code)
    local type = code2Type(code)
    if type == EEntityType.Player then
        return PlayerConfig.getAllInfo(code)
    elseif type == EEntityType.Wingman then
        return WingmanConfig.getAllInfo(code)
    elseif type == EEntityType.Boss then
        return BossConfig.getAllInfo(code)
    elseif type == EEntityType.Batman then
        return BatmanConfig.getAllInfo(code)
    elseif type == EEntityType.PlayerBullet then
        return PlayerBulletConfig.getAllInfo(code)
    elseif type == EEntityType.EnemyBullet then
        return EnemyBulletConfig.getAllInfo(code)
    elseif type == EEntityType.WingmanBullet then
        return {}
    elseif type == EEntityType.Prop then
        return PropConfig.getAllInfo(code)
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