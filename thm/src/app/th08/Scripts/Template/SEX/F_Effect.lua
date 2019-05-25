return {
    --敌人阵亡特效
    ccle_enemy_die_magic_01 = function (param)
        return { 
            cc.Animate:create(SpriteServer.createAnimation("etama2","etama2_51")),
            cc.Spawn:create({
                cc.ScaleBy:create(0.5,2.5),
                cc.FadeOut:create(0.5),
            })
        }
    end,

    ccle_player_die_magic_01 = function (param)
        return {  
            cc.Animate:create(SpriteServer.createAnimation("etama2","etama2_84")),
            cc.Spawn:create({
                cc.ScaleBy:create(0.5,10.5),
                cc.FadeOut:create(0.5),
            })
        }
    end,

    ccle_lightspot_01 = function (param)
        return {
            cc.Animate:create(SpriteServer.createAnimation("etama2","light_spot")),
            cc.Spawn:create({
                cc.FadeOut:create(2),
            })
        }
    end,
}