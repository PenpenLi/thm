
module("EntityUtil", package.seeall)
local EEntityType = GameDef.Stage.EEntityType
module(..., package.seeall)

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