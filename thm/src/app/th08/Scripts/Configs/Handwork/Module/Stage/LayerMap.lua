-- 实体与层级映射表
local EEntityType = Const.Stage.EEntityType
local EEntityLayerType = Const.Stage.EEntityLayerType

return {
    [EEntityType.Player] = EEntityLayerType.Player,
    [EEntityType.Wingman] = EEntityLayerType.Barrage,
    [EEntityType.Boss] = EEntityLayerType.Barrage,

    [EEntityType.Batman] = EEntityLayerType.Barrage,
    [EEntityType.PlayerBullet] = EEntityLayerType.Barrage,
    [EEntityType.EnemyBullet] = EEntityLayerType.Barrage,
    [EEntityType.WingmanBullet] = EEntityLayerType.Barrage,
}