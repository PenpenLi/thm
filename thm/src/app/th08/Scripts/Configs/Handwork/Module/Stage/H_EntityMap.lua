-- 实体映射表
local EEntityType = GameDef.Stage.EEntityType
local EBatmanType = GameDef.Stage.EBatmanType
local ERoleType = GameDef.Stage.ERoleType
local EBossType = GameDef.Stage.EBossType
local EEnemyBulletType = GameDef.Stage.EEnemyBulletType

return {
    [EEntityType.Player] = {
        [ERoleType.Reimu] = StageDefine.Reimu,
    },
    [EEntityType.Boss] = {
        [EBossType.WriggleNightbug] = StageDefine.WrigglePrefab,
    },
    [EEntityType.Batman] = {
        [EBatmanType.Fairy01] = StageDefine.Fairy01Prefab,
    },
    [EEntityType.EnemyBullet] = {
        [EEnemyBulletType.BigJade] = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Enemy.BigJadePrefab"),

    }



}