return {
    [301] = {
        name = "大玉",
        desc = "BigJade",
        gameArgs = {
            collider = {
                {
                    type = 1, --矩形
                    args = {
                        offset = cc.p(0,0),
                        size = cc.size(20,20),
                    }
                },

            },
            centerPoint = cc.p(0.5,0.5),        --中心锚点
            mapRotation = 0,                    --贴图旋转偏移
            bodySize = cc.size(16,16),           --贴图大小
            lethality = 9999,                    --致死量
            speed = 1,                              
        },
        animation = {
            idle = {},
        },
    },
    [302] = {
        name = "小玉",
        desc = "SmallJade",
        gameArgs = {
            colliderSize = cc.size(20,20),
            bodySize = cc.size(20,20),
        },
        animation = {
            idle = {},
        },
    }

}