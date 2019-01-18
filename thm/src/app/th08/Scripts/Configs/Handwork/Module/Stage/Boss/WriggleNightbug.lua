return {
    name = "莉格露·奈特巴格",
    nickName = "虫子",
    ability = "",
    desc1 = "虫子",
    gameArgs = {
        blood = 10000,  --血量
        moveSpeed = cc.p(2,2),
        colliderSize = cc.size(20,20),
        mapSize = cc.size(20,20),
    },
    animation = {
        stand_normal = {"stg1enm","wriggle_idle"},
        move_right_start = {"stg1enm","wriggle_move_right_start"},
        move_right_sustain = {"stg1enm","wriggle_move_right_susbin"},
        move_right = {"stg1enm","wriggle_move_right"},

        skill = {"stg1enm","wriggle_hand_up"},
        skill_susbin = {"stg1enm","wriggle_hand_up_susbin"},
    },
    spellcards = {
        [1] = "LilyWhite_01",
    }
}