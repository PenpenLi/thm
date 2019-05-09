module("EntityLayerMapConfig", package.seeall)
local EEntityType = GameDef.Stage.EEntityType
local EEntityLayerType = GameDef.Stage.EEntityLayerType
local _entityLayerMap = require "Scripts.Configs.Handwork.Module.Stage.H_EntityLayerMap"
local _defaultLayer = false

function getLayer(entityType)
    local func = _entityLayerMap[entityType]
    if type(func) == "function" then
        return func()
    end
end

function tryGetLayer(entityType)
    return getLayer(entityType) or _defaultLayer
end