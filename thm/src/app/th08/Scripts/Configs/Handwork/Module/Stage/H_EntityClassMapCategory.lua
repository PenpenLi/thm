
-- 实体映射表
local EEntityType = GameDef.Stage.EEntityType
local EPlayerType = GameDef.Stage.EPlayerType
local EBossType = GameDef.Stage.EBossType

return {
    [EEntityType.Player] = {
        [EPlayerType.Reimu] = "Scripts.Context.Game.Modules.Stage.Entity.Prefab.Player.Reimu",
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