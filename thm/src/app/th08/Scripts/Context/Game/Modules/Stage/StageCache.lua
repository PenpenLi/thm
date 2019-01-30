module(..., package.seeall)

local _bIsInStage = false
local _bIsTeam = false
local _eGroupType = false
local _eRoleType = RoleType.REIMU
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

function getStageId()
    return 4
end

function getMapId()
    return getStageId()
end



----
function clear()
    
end