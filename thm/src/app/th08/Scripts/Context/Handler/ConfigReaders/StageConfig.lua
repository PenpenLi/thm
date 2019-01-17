module("StageConfig", package.seeall)
local ROLE_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Role.%s"
local BOSS_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Boss.%s"
local BATMAN_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Batman.%s"
local SCENARIO_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Scenario.Stage_%02d"
local MAP_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Map.Map_%02d"
local BULLET_PLAYER_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Bullet.PlayerBullet"
local BULLET_ENEMY_PATH_PATTERN = "Scripts.Configs.Handwork.Module.Stage.Bullet.EnemyBullet"
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

function getBoss(bossType)
    return getDictByFile(BOSS_PATH_PATTERN,bossType)
end

function getBatman(batmanType)
    return getDictByFile(BATMAN_PATH_PATTERN,batmanType)
end

function getPlayerBullet(keyName)
    return getDictByFile(BULLET_PLAYER_PATH_PATTERN)
end

function getEnemyBullet(keyName)
    return getDictByFile(BULLET_ENEMY_PATH_PATTERN)
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


--[[敌机信息]]
--游戏参数
function getBossGameArgs(bossType)
    local tb = getBoss(bossType)
    return tb.gameArgs
end

function getBossAnimSheetArgs(bossType,name)
    local tb = getBoss(bossType)
    local args = tb.animation[name]
    if args then
        return unpack(args)
    end
    return {}
end

--[[小兵信息]]
--游戏参数
function getBatmanGameArgs(batmanType)
    local tb = getBatman(batmanType)
    return tb.gameArgs
end

function getBatmanAnimSheetArgs(batmanType,name)
    local tb = getBatman(batmanType)
    local args = tb.animation[name]
    if args then
        return unpack(args)
    end
    return {}
end