module("RoleConfig", package.seeall)

local ROLE_PATH_PATTERN = "Scripts.Configs.Handwork.Role.%s"


function getDict(roleType)
    local path = string.format(ROLE_PATH_PATTERN,roleType)
    local dict = require(path)
	return dict
end

function getAnimSheetByName(roleType,name)
    local tb = getDict(roleType)
    local args = tb.animation[name]
    if args then
        return unpack(args)
    end
end