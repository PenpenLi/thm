local ERoleType = GameDef.Stage.ERoleType
return {
    [ERoleType.Reimu] = {
        name = "博丽的巫女",
        cnName = "博丽的巫女",
        enName = " ",
        jpName = " ",
        nickName = "十万巫女",
        ability = "看见钱财服侍程度的能力",
        description = "",
        gameArgs = {
            moveStepSpeed = cc.p(4,4),              --移动速度
            slowStepSpeed = cc.p(2,2),              --慢速移动速度
            colliderSize = cc.size(20,20),      --判定点大小
            bodySize = cc.size(32,48),           --人物贴图大小
            brushSize = cc.size(32,48),         --擦弹范围
            wipeR = 30,                         --消弹的半径
            health = 100,                       --血量

        },
        
        animation = {
            
            animations = {
                move_left_start = {"player00","reimu_move_left_start"},
                move_left_sustain = {"player00","reimu_move_left_sustain"},
                move_left = {"player00","reimu_move_left"},
                stand_normal = {"player00","reimu_stand_normal"},
            },
        },
        character ={
            [1] = "",
        },
        effectInfo = {},

    },

}