return {
    name = "十六夜咲夜",
    desc1 = "Ko No Dio da!",
    ability = "暂停时间程度的能力",
    gameArgs = {
        moveSpeed = cc.p(2,2),
        colliderSize = cc.size(20,20),
        mapSize = cc.size(20,20),
    },
    animation = {
        move_left_start = {"player00","reimu_move_left_start"},
        move_left_sustain = {"player00","reimu_move_left_sustain"},
        move_left = {"player00","reimu_move_left",1/30},
        stand_normal = {"player00","reimu_stand_normal"},
    },
    spellcard = {

    },
}