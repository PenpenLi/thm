module("AnimationConfig", package.seeall)
local Animation = require "Scripts.Configs.Handwork.Animation"

function getDict(texType)
	local t = Animation[texType]
    return t
end

function getRes(texType,resName)
	local t = getDict(texType)
    return t[resName]
end

function getSize(texType,resName)
	local t = getDict(texType)
    return t[resName].rect
end

function getLength(texType,resName)
	local t = getDict(texType)
    return t[resName].length
end
