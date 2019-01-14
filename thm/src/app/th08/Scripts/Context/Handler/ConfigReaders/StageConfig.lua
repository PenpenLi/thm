module("StageConfig", package.seeall)
local ROLE_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Role.%s"
local SCENARIO_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Scenario.Stage_%02d"
local MAP_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Map.Map_%02d"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getScenario(id)
    local tb = getDictByFile(SCENARIO_PATH_PATTERN,id)
    return tb
end

function getMap(id)
    local tb = getDictByFile(MAP_PATH_PATTERN,id)
    return tb
end

function getRole(roleType)
    return getDictByFile(ROLE_PATH_PATTERN,roleType)
end


----
--[[自机信息]]
--游戏参数
function getRoleGameArgs(roleType)
    local tb = getRole(roleType)
    return tb.gameArgs
end

function getRoleAnimSheetArgs(roleType,name)
    local tb = getRole(roleType)
    local args = tb.animation[name]
    if args then
        return unpack(args)
    end
    return {}
end