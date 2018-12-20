module(..., package.seeall)

local ANIMATION_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Animation.%s"
local SCENARIO_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Scenario.Stage_%02d"

local _animationDict = false

function getAnime(roleType,actionType)
    local function getDict(roleType)
        if not _animationDict then
            local path = string.format(ANIMATION_PATH_PATTERN,roleType)
            _animationDict = _animationDict or {}
            _animationDict[roleType] = require(path)
        end
        return _animationDict[roleType]
    end
    local tb = getDict(roleType)
    return tb[actionType]
end

function getScenario(id)
    local function loadFileByid(id)
        local filePath = string.format(SCENARIO_PATH_PATTERN,id)
        return require(filePath)
    end
    return loadFileByid(id)
end

function getMap(id)
    
end