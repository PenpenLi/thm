module("ShapeConfig", package.seeall)
local _infoTb = false

local function getInfoTb()
    if not _infoTb then
        _infoTb = require("Scripts.Configs.Generate.G_Shape")
    end
    return _infoTb
end

function getAllInfo(code)
    return getInfoTb()[code]
end

function getCollider(code)
    function getExInfo(code)
        local info = getAllInfo(code)
        if info then
            return info.collider
        end
        return nil
    end
end

function getDecisionPoint(code)
    function getExInfo(code)
        local info = getAllInfo(code)
        if info then
            return info.decisionPoint
        end
        return nil
    end
end