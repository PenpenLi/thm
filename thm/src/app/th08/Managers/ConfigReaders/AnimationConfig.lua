module("AnimationConfig", package.seeall)
local Animation = require "Configs.Handwork.Animation"

function getResInfo(texType,resName)
    local t = Animation[texType]
    if t then
        return t[resName]
    end
end