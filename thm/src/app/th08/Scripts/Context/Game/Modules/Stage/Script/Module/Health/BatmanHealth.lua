
local M = class("BatmanHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

end
--
----
function M:_onHurt()
    --闪烁特效
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.Blink:create(0.1, 5))

end

function M:_onDead()
    --这里代表击中,而不是对象消亡
    GlobalUtil.playSEXEffect({
        refNode = self:getEntity(),
        source = {EffectType.PUBLIC,"ccle_die_magic_01"},
    })
    --TODO:还需要播放一个粒子效果
    self:killEntity()

end

return M