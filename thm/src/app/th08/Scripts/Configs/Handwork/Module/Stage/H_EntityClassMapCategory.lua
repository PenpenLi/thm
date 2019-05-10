
-- 实体映射表
local EEntityType = GameDef.Stage.EEntityType
local ERoleType = GameDef.Stage.ERoleType
local EBossType = GameDef.Stage.EBossType

return {
    [EEntityType.Player] = {
        [ERoleType.Reimu] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Player.Reimu",
    },
    [EEntityType.Wingman] = {

    },
    [EEntityType.Boss] = {
        [EBossType.Wriggle] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Boss.Wriggle",
    },
    [EEntityType.Batman] = {
        
    },
    [EEntityType.PlayerBullet] = {
        
    },
    [EEntityType.EnemyBullet] = {
        
    },
    [EEntityType.WingmanBullet] = {
        
    },
    [EEntityType.Prop] = {
        
    },
}