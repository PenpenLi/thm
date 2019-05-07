-- 实体映射表
local EEntityType = GameDef.Stage.EEntityType
local ERoleType = GameDef.Stage.ERoleType
local EBossType = GameDef.Stage.EBossType

return {
    [EEntityType.Player] = {
        [ERoleType.Reimu] = StageDefine.Reimu,
    },
    [EEntityType.Boss] = {
        [EBossType.Wriggle] = StageDefine.Wriggle,
    },
    


}