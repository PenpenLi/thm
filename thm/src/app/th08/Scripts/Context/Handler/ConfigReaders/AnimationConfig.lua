module("AnimationConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Animations")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end

function getExInfo(code)
    local info = getAllInfo(code)
    if info then
        return json.decode(info.exInfo)
    end
    return ""
end

function getSrcPath(code)
    local info = getAllInfo(code)
    if info then
        return info.atlas,info.skeleton
    end
    return nil,nil
end

function getAnchorPoint(code)
    local info = getAllInfo(code)
    if info then
        return info.anchorPoint
    end
    return {x = 0.5, y = 0.5}
end

function getScale(code)
    local info = getAllInfo(code)
    if info then
        return info.scale
    end
    return {x = 1.0, y = 1.0}
end

function getRotation(code)
    local info = getAllInfo(code)
    if info then
        return info.rotation
    end
    return 0
end
---