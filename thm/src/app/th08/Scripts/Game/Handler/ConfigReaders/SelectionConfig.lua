module("SelectionConfig", package.seeall)

local _Dict = false

local function getDict()
    if not _Dict then
        _Dict = require("Scripts.Configs.Handwork.SelectionMisc")
    end
    return _Dict
end

local function getDiffDict()
    local dict = getDict()
    return dict.difficulty
end

local function getRoleDict()
    local dict = getDict()
    return dict.roles
end

function getDiffHideCnt()
    local dict = getDiffDict()
    return dict.hideCnt
end

function getDiffInfos()
    local dict = getDiffDict()
    return dict.levelCfg
end