
local M = class("BatmanHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

end
--
----
function M:_onHurt()
    --闪烁特效
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.Sequence:create({
        cc.Blink:create(0.1, 6),
        cc.CallFunc:create(function ()
            local spriteComp = self:getComponent("SpriteComponent")
            spriteComp:getSprite():setOpacity(255)
            spriteComp:getSprite():setVisible(true)
        end)
    }))

end

function M:_onDead()
    --这里代表击中,而不是对象消亡
    GlobalUtil.playSEXEffect({
        refNode = self:getEntity(),
        source = {EffectType.PUBLIC,"ccle_die_magic_01"},
    })
    --TODO:还需要播放一个粒子效果
    self:killEntity()


    --TODO:爆道具
end

return M