return {
    public = {
        --敌人阵亡特效
        ccle_die_magic_01 = function (param)
            return {  
                cc.Animate:create(AnimationCache.getSheetRes("enemt_breaked")),
                cc.Spawn:create({
                    cc.ScaleBy:create(0.5,2.5),
                    cc.FadeOut:create(0.5),
                })
            }
        end,

        ccle_lightspot_01 = function (param)
            return {
                cc.Animate:create(AnimationCache.getSheetRes("light_spot_01")),
                cc.Spawn:create({
                    cc.FadeOut:create(2),
                })
            }
        end,

    },
    
}