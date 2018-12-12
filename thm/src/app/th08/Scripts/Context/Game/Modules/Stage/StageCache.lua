module(..., package.seeall)

local _bIsInStage = false
function isInStage()
    return _bIsInStage
end

function setInStage(state)
    _bIsInStage = state
end

----
function clear()
    
end