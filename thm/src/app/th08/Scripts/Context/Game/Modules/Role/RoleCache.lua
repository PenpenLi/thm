module(..., package.seeall)
local _roleType = RoleType.REIMU
function setType(type)
    _roleType = type
end

function getType()
    return _roleType
end

function getLevel()

end

function getPower()
    
end

----
function getCurAnimSheetByName(name)
    return RoleConfig.getAnimSheetByName(getType(),name)
end


----
function clear()
    
end