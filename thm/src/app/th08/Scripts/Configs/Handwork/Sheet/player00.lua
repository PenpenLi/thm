return {
    source = "Assets/UI/Stage/Player/player00.png",
    desc = "Reimu和Yukari的精灵集信息",
    frame = {

    },
    sequence = {    
        reimu_stand_normal = {
            desc = "",
            grid = {
                length = 4,
                rect = {x = 0,y = 0,width = 4*32,height = 48},
            }
        },
        reimu_move_left = {
            desc = "",
            grid = {    
                length = 7,
                rect = {x = 0,y = 48,width = 7*32,height = 48},
            }
        },

        reimu_move_left_start = {
            desc = "",
            grid = {    
                length = 2,
                rect = {x = 0,y = 48,width = 2*32,height = 48},
            }
        },

        reimu_move_left_sustain = {
            desc = "",
            grid = {    
                length = 5,
                rect = {x = 2*32,y = 48,width = 5*32,height = 48},
            }
        },

        reimu_bullet_01_normal = {
            desc = "",
            grid = {    
                length = 1,
                rect = {x = 0,y = 3*48,width = 2*32,height = 16}
            }
        },

        reimu_bullet_02_normal = {
            desc = "",
            grid = {    
                length = 1,
                rect = {x = 2*16,y = 11*16,width = 1*16,height = 1*16}
            }
        },

        --[[yukari]]
        yukari_stand_normal = {
            desc = "",
            grid = {    
                length = 4,
                rect = {x = 4*32,y = 0,width = 4*32,height = 48},
            }
        },

        yukari_move_left = {
            desc = "",
            grid = {    
                length = 7,
                rect = {x = 0,y = 2*48,width = 7*32,height = 48},
            }
        },

        yukari_move_left_start = {
            desc = "",
            grid = {    
                length = 2,
                rect = {x = 0,y = 2*48,width = 2*32,height = 48},
            }
        },

        yukari_move_left_sustain = {
            desc = "",
            grid = {    
                length = 5,
                rect = {x = 2*32,y = 2*48,width = 5*32,height = 48},
            }
        },

    }
}