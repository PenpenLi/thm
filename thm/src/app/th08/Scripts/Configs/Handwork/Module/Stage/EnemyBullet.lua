return {
    ["BigJade"] = {
        name = "大玉",
        gameArgs = {
            collider = {
                type = 1, --矩形
                args = {
                    size = cc.size(20,20),
                }
            },
            bodySize = cc.size(20,20),           --贴图大小
            lethality = 9999                    --致死量
        },
        animation = {
            idle = {},
        },
    },
    ["SmallJade"] = {
        name = "小玉",
        gameArgs = {
            colliderSize = cc.size(20,20),
            bodySize = cc.size(20,20),
        },
        animation = {
            idle = {},
        },
    }

}