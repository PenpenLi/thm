
return {
    font = {
        fnt = {
            menu_font_black = "Assets/Font/Fnt/menu_font_black.fnt" ,
            menu_font_white = "Assets/Font/Fnt/menu_font_white.fnt" ,
        },
    },
    texture = {
        sheet = {
            ---
            stg01_bg = {
                source =  "Assets/Texture/Sheet/stg1bg.png" ,
                rect = {x = 0,y = 0, width = 257,height = 258}
            },
        
            stg01_cloud_01 = {
                source =  "Assets/Texture/Sheet/stg1bg.png" ,
                rect = {x = 262,y = 18, width = 108,height = 108}
            },
        
            stg01_cloud_02 = {
                source =  "Assets/Texture/Sheet/stg1bg.png" ,
                rect = {x = 394,y = 10, width = 108,height = 108}
            },
        },
        plist = {
            select_diff = "Assets/Texture/Plist/select_diff.plist" ,
        },
    },
    animation = {
        sheet = {
            --[[reimu]]
            reimu_stand_normal = {
                source = "Assets/Texture/Sheet/player00.png" ,
                length = 4,
                rect = {x = 0,y = 0,width = 4*32,height = 48},
            },

            reimu_move_left = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 7,
                rect = {x = 0,y = 48,width = 7*32,height = 48},
            },

            reimu_move_left_start = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 2,
                rect = {x = 0,y = 48,width = 2*32,height = 48},
            },

            reimu_move_left_sustain = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 5,
                rect = {x = 2*32,y = 48,width = 5*32,height = 48},
            },

            reimu_bullet_01_normal = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 1,
                rect = {x = 0,y = 3*48,width = 2*32,height = 16}
            },

            --[[yukari]]
            yukari_stand_normal = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 4,
                rect = {x = 4*32,y = 0,width = 4*32,height = 48},
            },

            yukari_move_left = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 7,
                rect = {x = 0,y = 2*48,width = 7*32,height = 48},
            },

            yukari_move_left_start = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 2,
                rect = {x = 0,y = 2*48,width = 2*32,height = 48},
            },

            yukari_move_left_sustain = {
                source = "Assets/Texture/Sheet/player00.png",
                length = 5,
                rect = {x = 2*32,y = 2*48,width = 5*32,height = 48},
            },

            --[[enemy]]
            enemy_01_a_normal = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 4,
                rect = {x = 0*32,y = 0*32,width = 4*32,height = 1*32},
            },
            enemy_01_a_right_fly = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 1,
                rect = {x = 4*32,y = 0*32,width = 1*32,height = 1*32},
            },
            enemy_01_a_fly_stand = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 3,
                rect = {x = 5*32,y = 0*32,width = 3*32,height = 1*32},
            },
            enemy_01_b_normal = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 4,
                rect = {x = 8*32,y = 0*32,width = 4*32,height = 1*32},
            },
            enemy_01_b_right_fly = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 1,
                rect = {x = 12*32,y = 0*32,width = 1*32,height = 1*32},
            },
            enemy_01_b_fly_stand = {
                source = "Assets/Texture/Sheet/enemy.png",
                length = 3,
                rect = {x = 13*32,y = 0*32,width = 3*32,height = 1*32},
            },
            
            --[[Public]]
            enemt_breaked = {
                source = "Assets/Texture/Sheet/etama2.png",
                length = 1,
                rect = {x = 12*16,y = 11*16,width = 64,height = 64},
            },

            light_spot_01 = {
                source = "Assets/Texture/Sheet/etama2.png",
                length = 4,
                rect = {x = 0*16,y = 15*16,width = 4*16,height = 16},
            },

  
        },
        plist = {
            select_diff = {
                
            }
            

        },

    },

    particle = {
        public = {
            ccp_gk_default_01 = "Assets/SFX/Particle/ccp_gk_default_01.plist",
            ccp_gk_heart_01 = "Assets/SFX/Particle/ccp_gk_heart_01.plist",
        },
    },

    sound = {

    },

    ui = {
       button = {
            btn_base_yellow = "Assets/UI/Button/btn_base_yellow.png" ,
       }


    },
    ------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------
    public = {

    },

    role = {

    },

    menu = {

        main_menu = {
            main_bg = "",
        },

    },

    selection = {
        selection_bg = "Assets/Selection/selection_bg",
        
        diff_1_off = "Assets/Selection/SelectDifficulty/diff_1_off.png" ,
        diff_1_on = "Assets/Selection/SelectDifficulty/diff_1_on.png" ,
        diff_2_off = "Assets/Selection/SelectDifficulty/diff_2_off.png" ,
        diff_2_on = "Assets/Selection/SelectDifficulty/diff_2_on.png" ,
        diff_3_off = "Assets/Selection/SelectDifficulty/diff_3_off.png" ,
        diff_3_on = "Assets/Selection/SelectDifficulty/diff_3_on.png" ,
        diff_4_off = "Assets/Selection/SelectDifficulty/diff_4_off.png" ,
        diff_4_on = "Assets/Selection/SelectDifficulty/diff_4_on.png" ,
        diff_5_off = "Assets/Selection/SelectDifficulty/diff_5_off.png" ,
        diff_5_on = "Assets/Selection/SelectDifficulty/diff_5_on.png" ,
        diff_title = "Assets/Selection/SelectDifficulty/diff_title.png" ,

        sl_pl00a = "Assets/Selection/SelectRole/sl_pl00a.png" ,
        sl_pl00h = "Assets/Selection/SelectRole/sl_pl00h.png" ,
        sl_pl01a = "Assets/Selection/SelectRole/sl_pl01a.png" ,
        sl_pl01h = "Assets/Selection/SelectRole/sl_pl01h.png" ,
        sl_pl02a = "Assets/Selection/SelectRole/sl_pl02a.png" ,
        sl_pl02h = "Assets/Selection/SelectRole/sl_pl02h.png" ,
        sl_pl03a = "Assets/Selection/SelectRole/sl_pl03a.png" ,
        sl_pl03h = "Assets/Selection/SelectRole/sl_pl03h.png" ,
        sl_pltxt0 = "Assets/Selection/SelectRole/sl_pltxt0.png" ,
        sl_pltxt1 = "Assets/Selection/SelectRole/sl_pltxt1.png" ,
        sl_pltxt2 = "Assets/Selection/SelectRole/sl_pltxt2.png" ,
        sl_pltxt3 = "Assets/Selection/SelectRole/sl_pltxt3.png" ,
        sl_pltxt4 = "Assets/Selection/SelectRole/sl_pltxt4.png" ,
        sl_pltxt5 = "Assets/Selection/SelectRole/sl_pltxt5.png" ,
        sl_pltxt6 = "Assets/Selection/SelectRole/sl_pltxt6.png" ,
        sl_pltxt7 = "Assets/Selection/SelectRole/sl_pltxt7.png" ,
        sl_pltxt8 = "Assets/Selection/SelectRole/sl_pltxt8.png" ,
        sl_pltxt9 = "Assets/Selection/SelectRole/sl_pltxt9.png" ,
        sl_pltxt10 = "Assets/Selection/SelectRole/sl_pltxt10.png" ,
        sl_pltxt11 = "Assets/Selection/SelectRole/sl_pltxt11.png" ,
        sl_text = "Assets/Selection/SelectRole/sl_text.png" ,

    },

    main_ui = {
            
    },

    loading = {
        loading_icon_1 = "Assets/GUI/PublicUI/Loading/loading_icon_1.png" ,
        loading_icon_2 = "Assets/GUI/PublicUI/Loading/loading_icon_2.png" ,
        loading_logo = "Assets/GUI/PublicUI/Loading/loading_logo.jpg" ,
        loading_word_cn = "Assets/GUI/PublicUI/Loading/loading_word_cn.png" ,
        loading_word_en = "Assets/GUI/PublicUI/Loading/loading_word_en.png" ,
    },



}