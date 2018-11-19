module("AnimationConfig", package.seeall)
local Animation = require "Configs.Handwork.Animation"

function getDict(texType)
	local t = Animation[texType]
    return t
end

function getRes(texType,resName)
	local t = getDict(texType)
    return t[resName]
end
