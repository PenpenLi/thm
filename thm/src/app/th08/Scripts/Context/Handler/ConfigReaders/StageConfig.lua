module("StageConfig", package.seeall)


local ROLE_FILE = "Scripts.Configs.Handwork.Module.Stage.H_Role"
local BOSS_FILE = "Scripts.Configs.Handwork.Module.Stage.H_Boss"
local BATMAN_FILE = "Scripts.Configs.Handwork.Module.Stage.H_Batman"
local BULLET_PLAYER_FILE = "Scripts.Configs.Handwork.Module.Stage.H_PlayerBullet"
local BULLET_ENEMY_FILE = "Scripts.Configs.Handwork.Module.Stage.H_EnemyBullet"
local PROP_ENEMY_FILE = "Scripts.Configs.Handwork.Module.Stage.H_Prop"

local ENTITY_MAP_FILE = "Scripts.Configs.Handwork.Module.Stage.H_EntityMap"
local LAYER_MAP_FILE = "Scripts.Configs.Handwork.Module.Stage.H_LayerMap"

local function getDictByFile(path)
    local pathFile = string.format(path)
    return require(pathFile)
end

local function getDictByPattern(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end


function getRole(roleType)
    return getDictByFile(ROLE_FILE)[roleType]
end

function getBoss(bossType)
    return getDictByFile(BOSS_FILE)[bossType]
end

function getBatman(batmanType)
    return getDictByFile(BATMAN_FILE)[batmanType]
end

function getPlayerBullet(bulletType)
    return getDictByFile(BULLET_PLAYER_FILE)[bulletType]
end

function getEnemyBullet(bulletType)
    return getDictByFile(BULLET_ENEMY_FILE)[bulletType]
end

function getProp(propType)
    return getDictByFile(BULLET_ENEMY_FILE)[propType]
end

----
--[[自机信息]]
--游戏参数
function getRoleGameArgs(roleType)
    local tb = getRole(roleType)
    return tb.gameArgs
end

function getRoleAnimationDBXFile(roleType)
    local tb = getRole(roleType)
    local args = tb.animation.src
    if args then
        return unpack(args)
    end
    return {}
end

function getRoleAnimationArgs(roleType,name)
    local tb = getRole(roleType)
    local args = tb.animation.animations[name]
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

---
function getPropGameArgs(propType)
    local tb = getProp(propType)
    return tb.gameArgs
end

function getPropFrameSheetArgs(propType)
    local tb = getProp(propType)
    local args = tb.frame
    if args then
        return unpack(args)
    end
    return {}
end
----------------
----------------
function getEntityClass(category,type)
    local tb = getDictByFile(ENTITY_MAP_FILE)[category]
    return tb[type]
end

function getEntityLayerType(category)
    local tb = getDictByFile(LAYER_MAP_FILE)
    return tb[category]
end