module("SheetConfig", package.seeall)
local Sheet = require "Configs.Handwork.Sheet"

function getRes(resName)
	local info = Sheet[resName]
    return info
end
