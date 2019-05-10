module("EntityClassMapConfig", package.seeall)

local EEntityType = GameDef.Stage.EEntityType
local _entityMapCode = require "Scripts.Configs.Handwork.Module.Stage.H_EntityClassMapCode"
local _entityMapCategory = require "Scripts.Configs.Handwork.Module.Stage.H_EntityClassMapCategory"
local _defaultTb = {
    [EEntityType.Player] = false,
    [EEntityType.Wingman] = false,
    [EEntityType.Boss] = false,
    [EEntityType.Batman] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.BatmanPrefab",
    [EEntityType.PlayerBullet] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.PlayerBulletPrefab",
    [EEntityType.EnemyBullet] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.EnemyBulletPrefab",
    [EEntityType.WingmanBullet] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.WingmanBulletPrefab",
    [EEntityType.Prop] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.PropPrefab",
}
function getClassByCode(code)
    return _entityMapCode[code] and require(_entityMapCode[code])
end

function getClassByCategory(category,type)
    return _entityMapCategory[category] and require(_entityMapCategory[category][type])
end

function getClass(arg1,arg2)
    if arg2 == nil then
        return getClassByCode(arg1)
    else
        return getClassByCategory(category,type)
    end
end

function tryGetClass(arg1,arg2)
    if arg2 == nil then
        local entityType = EntityUtil.code2Type(arg1)
        return getClassByCode(arg1) or (_defaultTb[entityType] and require(_defaultTb[entityType]))
    else
        return getClassByCategory(arg1,arg2) or (_defaultTb[arg1] and require(_defaultTb[arg1]))
    end
end