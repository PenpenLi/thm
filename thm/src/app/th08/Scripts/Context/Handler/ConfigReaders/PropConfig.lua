module("PropConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Prop")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end

function getEffect(code)
    local info = getAllInfo(code)
    return info.effect or 0
end

function getEffectEx(code)
    local info = getAllInfo(code)
    return info.effectEx or 0
end

function getEffectStr(code)
    local info = getAllInfo(code)
    return info.effectStr or 0
end