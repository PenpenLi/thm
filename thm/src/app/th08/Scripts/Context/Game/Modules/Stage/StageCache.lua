module(..., package.seeall)
local EEntityType = GameDef.Stage.EEntityType
local ERoleType = GameDef.Stage.ERoleType
local EModeType = GameDef.Stage.EModeType
--
local _bIsInStage = false
local _bIsTeam = false
local _eGroupType = false
local _eRoleType = ERoleType.Reimu
local _eStageMode = EModeType.BossRush

function setGroupType(val)
    _eGroupType = val
end

function getGroupType()
    return _eGroupType
end

function setRoleType(val)
    _eRoleType = val
end

function getRoleType()
    return _eRoleType
end

function isTeam()
    return _bIsTeam
end

function isInStage()
    return _bIsInStage
end

function setInStage(state)
    _bIsInStage = state
end
function getStageMode()
    return _eStageMode
end

function setStageMode(mode)
    _eStageMode = mode
end

---

function getStageId()
    return 6
end

function getMapId()
    return getStageId()
end

----
local _allEntities = {}
function addToEntityCache(entity)
    local entityType = entity:getScript("EntityController").entityType
    _allEntities = _allEntities or {}
    _allEntities[entityType] = _allEntities[entityType] or {}
    _allEntities[entityType][entity] = entity
end

function removeToEntityCache(entity)
    local entityType = entity:getScript("EntityController").entityType
    _allEntities = _allEntities or {}
    _allEntities[entityType] = _allEntities[entityType] or {}
    _allEntities[entityType][entity] = nil
end

function getEntities(category)
    local tb = _allEntities[category]
    return tb
 end

function getBossEntity()
    local tb = getEntities(EEntityType.Boss)
    return tb and tb[1]
end

function getPlayerEntity()
    local tb = getEntities(EEntityType.Player)
    return tb and tb[1]
end

----
function clear()
    _allEntities = {}
end