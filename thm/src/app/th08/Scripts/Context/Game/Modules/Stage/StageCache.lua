module(..., package.seeall)

local _bIsInStage = false
function isInStage()
    return _bIsInStage
end

function setInStage(state)
    _bIsInStage = state
end

function getStageId()
    return 1
end

function getMapId()
    return getStageId()
end

----
function getCurRoleAnimSheetArgs(name)
    return StageConfig.getRoleAnimSheetArgs(Cache.roleCache.getType(),name)
end


----
function clear()
    
end