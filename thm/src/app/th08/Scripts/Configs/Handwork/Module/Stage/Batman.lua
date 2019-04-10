local EBatmanType = GameDef.Stage.EBatmanType
return {
    [EBatmanType.Fairy01] = {
        name = "妖精01",
        description = "",
        ability = "",
        animation = {
            stand_normal = {"enemy","enemy_01_a_normal"},
            move_right = {"enemy","enemy_01_a_right_fly"},
            move_turn = {"enemy","enemy_01_a_fly_stand"},
        },
    }
    
}