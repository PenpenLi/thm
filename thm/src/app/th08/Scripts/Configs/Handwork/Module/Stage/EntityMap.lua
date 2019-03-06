-- 实体映射表
local EEntityType = Const.Stage.EEntityType
local EBatmanType = Const.Stage.EBatmanType
local EBossType = Const.Stage.EBossType
local EEnemyBulletType = Const.Stage.EEnemyBulletType

return {
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