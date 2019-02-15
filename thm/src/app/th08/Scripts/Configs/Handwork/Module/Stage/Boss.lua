return {

    ["WriggleNightbug"] = {
        name = "莉格露·奈特巴格",
        cnName = "莉格露·奈特巴格",
        enName = "Wriggle Nightbug",
        jpName = "リグル·ナイトバグ",
        nickName = "虫子",
        ability = "",
        description = "虫子而已",
        
        gameArgs = {
            health = 10000,  --血量
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
        barrage = {
            spellcards = {
                [1] = "SC_01",
            },
        },
        character ={
            [1] = "",
        },
    },
    ["LilyWhite"]= {
        name = "莉莉白",
        nickName = "叫春精",
        ability = "传播春天程度的能力",
        description = "叫春精",

    },
}