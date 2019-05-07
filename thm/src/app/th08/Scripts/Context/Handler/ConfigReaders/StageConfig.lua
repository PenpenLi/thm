module("StageConfig", package.seeall)
local ROLE_FILE = "Scripts.Configs.Handwork.Module.Stage.H_Role"

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

---
function getEntityClass(category,type)
    local tb = getDictByFile(ENTITY_MAP_FILE)[category]
    return tb[type]
end

function getEntityLayerType(category)
    local tb = getDictByFile(LAYER_MAP_FILE)
    return tb[category]
end