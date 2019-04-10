local EPlaerBulletType = GameDef.Stage.EPlaerBulletType
return {
    [EPlaerBulletType.JiAmulet] = {
        name = "咒符·集",
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
            centerPoint = cc.p(0.5,0.5),        --中心锚点位置
            mapRotation = 0,                    --贴图旋转偏移
            bodySize = cc.size(16,16),           --贴图大小
            lethality = 9999,                    --致死量
            speed = 10,                              
        },
        animation = {
            idle = {},
        },
    },

    [EPlaerBulletType.SanAmulet] = {
        name = "咒符·散",    
    },
    
}