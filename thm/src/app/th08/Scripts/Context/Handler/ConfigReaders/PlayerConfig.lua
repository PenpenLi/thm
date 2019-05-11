module("PlayerConfig", package.seeall)
local _misc = require("Scripts.Configs.Handwork.Module.Stage.H_PlayerMisc")
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Player")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end

function getBulletCode( code )
    return _misc[code].bulletCode
end