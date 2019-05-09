module(..., package.seeall)
local M = class("StageCache", THSTG.CORE.Cache)

local EEntityType = GameDef.Stage.EEntityType
local ERoleType = GameDef.Stage.ERoleType
local EModeType = GameDef.Stage.EModeType
--
local _bIsInStage = false
local _bIsTeam = false
local _eGroupType = false
local _eRoleType = ERoleType.Reimu
local _eStageMode = EModeType.BossRush

function M:setGroupType(val)
    _eGroupType = val
end

function M:getGroupType()
    return _eGroupType
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
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    _allEntities = _allEntities or {}
    _allEntities[entityType] = _allEntities[entityType] or {}
    _allEntities[entityType][entity] = entity
end

function M:removeFromEntityCache(entity)
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    _allEntities = _allEntities or {}
    _allEntities[entityType] = _allEntities[entityType] or {}
    _allEntities[entityType][entity] = nil
end

function M:getEntities(category)
    local tb = _allEntities[category]
    return tb
 end

function M:getBossEntity()
    local tb = getEntities(EEntityType.Boss)
    return tb and tb[1]
end

function M:getPlayerEntity()
    local tb = getEntities(EEntityType.Player)
    return tb and tb[1]
end

----
function M:clear()
    _allEntities = {}
end

return M