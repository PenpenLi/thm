module("BossConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Boss")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end
