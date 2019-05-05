module("AnimationConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Animations")
    end
    return _infoTb
end

function getAnimationInfo(uid)
    
end

