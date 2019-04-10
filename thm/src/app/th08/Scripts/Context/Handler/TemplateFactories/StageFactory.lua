module("StageFactory", package.seeall)

local SCENARIO_PATH_PATTERN = "Scripts.Template.Module.Stage.Scenario.Stage_%02d"
local MAP_PATH_PATTERN = "Scripts.Template.Module.Stage.Map.Map_%02d"

local function getDictByPattern(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getScenario(id)
    local tb = getDictByPattern(SCENARIO_PATH_PATTERN,id)
    return tb
end

function getMap(id)
    local tb = getDictByPattern(MAP_PATH_PATTERN,id)
    return tb
end