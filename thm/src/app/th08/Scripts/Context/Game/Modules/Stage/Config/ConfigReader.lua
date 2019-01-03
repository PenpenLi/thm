module(..., package.seeall)

local ACTION_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Action.%s"
local EFFECT_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Effect.%s"
local SCENARIO_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Scenario.Stage_%02d"
local MAP_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Config.Map.Map_%02d"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getAction(roleType,actionType)
    local tb = getDictByFile(ACTION_PATH_PATTERN,roleType)
    return tb[actionType]
end

function getEffect(effectType,name)
    local tb = getDictByFile(EFFECT_PATH_PATTERN,effectType)
    return tb[name]
end

function getScenario(id)
    local tb = getDictByFile(SCENARIO_PATH_PATTERN,id)
    return tb
end

function getMap(id)
    local tb = getDictByFile(MAP_PATH_PATTERN,id)
    return tb
end