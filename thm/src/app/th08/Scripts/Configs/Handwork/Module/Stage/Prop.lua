return {
    ["Prop_P"] = {
        name = "P弹",
        description = "给予能量",
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
    ["Prop_B"] = {
        gameArgs = {
            colliderSize = cc.size(16,16),
            bodySize = cc.size(16,16),
        },
        
    }



}