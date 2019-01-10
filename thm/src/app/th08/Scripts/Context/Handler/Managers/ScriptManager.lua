module("ScriptManager", package.seeall)

local ACTION_PATH_PATTERN = "Scripts.Configs.Script.Action.%s"
local SCENARIO_PATH_PATTERN = "Scripts.Configs.Script.Scenario.Stage_%02d"
local MAP_PATH_PATTERN = "Scripts.Configs.Script.Map.Map_%02d"

local EFFECT_PATH_PATTERN = "Scripts.Configs.Script.SFX.Effect.Effect"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getAction(roleType,actionType)
    local tb = getDictByFile(ACTION_PATH_PATTERN,roleType)
    return tb[actionType]
end

function getScenario(id)
    local tb = getDictByFile(SCENARIO_PATH_PATTERN,id)
    return tb
end

function getMap(id)
    local tb = getDictByFile(MAP_PATH_PATTERN,id)
    return tb
end

function getSFXEffectDict() 
    local tb = getDictByFile(EFFECT_PATH_PATTERN)
    return tb
end
function getSFXEffect(effectType,name) return getSFXEffectDict()[effectType][name] end