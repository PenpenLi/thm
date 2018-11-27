module("SelectDiffConfig", package.seeall)

local _Dict = false

local function getDict()
    if not _Dict then
        _Dict = require("Scripts.Configs.Handwork.SelectDiffMisc")
    end
    return _Dict
end

function getInfos()
    local dict = getDict()
    return dict
end