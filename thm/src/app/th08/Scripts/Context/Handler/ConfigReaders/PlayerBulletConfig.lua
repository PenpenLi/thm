module("PlayerBulletConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_PlayerBullet")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end
