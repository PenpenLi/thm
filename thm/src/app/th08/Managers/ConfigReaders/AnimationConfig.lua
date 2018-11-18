module("AnimationConfig", package.seeall)
local Animation = require "Configs.Handwork.Animation"

function getResDict(texType)
    local t = Animation[texType]
    return t
end

function getResInfo(texType,resName)
    local t = getResDict(texType)
    if t then
        return t[resName]
    end
end