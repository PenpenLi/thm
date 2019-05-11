module("WingmanConfig", package.seeall)
local _misc = require("Scripts.Configs.Handwork.Module.Stage.H_WingmanMisc")
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Wingman")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end

function getBulletCode(code)
    return _misc[code].bulletCode
end