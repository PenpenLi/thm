return {
    --敌人阵亡特效
    enemy_die_01 = function ()
        return {
            cc.Animate:create(AnimationCache.getSheetRes("enemt_breaked")),
            cc.Spawn:create({
                cc.ScaleBy:create(0.5,2.5),
                cc.FadeOut:create(0.5)
            })
        }
    end
}