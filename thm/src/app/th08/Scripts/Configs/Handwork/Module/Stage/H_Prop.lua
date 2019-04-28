local EPropType = GameDef.Stage.EPropType
return {
    [EPropType.Power] = {
        name = "P弹",
        description = "给予火力能量",
        gameArgs = {
            colliderSize = cc.size(16,16),
            bodySize = cc.size(16,16),
        },
        animation = {
            idle = {"etama2","prop_p"},
        },
        effectFunc = function(player)

        end
    },
    [EPropType.Bomb] = {
        name = "B弹",
        description = "给予一次Bomb的机会",
        gameArgs = {
            colliderSize = cc.size(16,16),
            bodySize = cc.size(16,16),
        },
        
    }



}