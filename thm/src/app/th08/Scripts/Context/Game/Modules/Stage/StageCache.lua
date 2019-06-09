module(..., package.seeall)
local M = class("StageCache", THSTG.CORE.Cache)

local EEntityType = GameDef.Stage.EEntityType
local EPlayerType = GameDef.Stage.EPlayerType
local EModeType = GameDef.Stage.EModeType
--
local _bIsInStage = false
local _bIsTeam = false
local _eTeamType = false
local _eRoleType = EPlayerType.Reimu
local _eStageMode = EModeType.BossRush

function M:setTeamType(val)
    _eTeamType = val
end

function M:getTeamType()
    return _eTeamType
end

function M:setRoleType(val)
    _eRoleType = val
end

function M:getRoleType()
    return _eRoleType
end

function M:isTeam()
    return _bIsTeam
end

function M:isInStage()
    return _bIsInStage
end

function M:setInStage(state)
    _bIsInStage = state
end
function M:getStageMode()
    return _eStageMode
end

function M:setStageMode(mode)
    _eStageMode = mode
end

---

function M:getStageId()
    return 6
end

function M:getMapId()
    return getStageId()
end

----
local _allEntities = {}
function M:addToEntityCache(entity)
    local entityId = entity:getID()
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    if entityType then
        _allEntities = _allEntities or {}
        _allEntities[entityType] = _allEntities[entityType] or {}
        _allEntities[entityType][entityId] = entity
    end
end

function M:removeFromEntityCache(entity)
    local entityId = entity:getID()
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    if entityType then
        _allEntities = _allEntities or {}
        _allEntities[entityType] = _allEntities[entityType] or {}
        _allEntities[entityType][entityId] = nil
    end
end

function M:getEntities(category)
    local tb = _allEntities[category]
    return tb
 end

function M:getBatmanEntities()
    local tb = self:getEntities(EEntityType.Batman)
    return tb
end

function M:getEnemyBulletEntities()
    local tb = self:getEntities(EEntityType.EnemyBullet)
    return tb
end

function M:getPlayerBulletEntities()
    local tb = self:getEntities(EEntityType.PlayerBullet)
    return tb
end

function M:getBossEntity()
    local tb = self:getEntities(EEntityType.Boss)
    return tb and tb[next(tb)]
end

function M:getPlayerEntity()
    local tb = self:getEntities(EEntityType.Player)
    return tb and tb[next(tb)]
end

----
function M:clear()
    _allEntities = {}
end

return M