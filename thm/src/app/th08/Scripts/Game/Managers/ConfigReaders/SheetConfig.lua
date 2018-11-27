module("SheetConfig", package.seeall)
local Sheet = require "Scripts.Configs.Handwork.Sheet"

function getRes(resName)
	local info = Sheet[resName]
    return info
end
