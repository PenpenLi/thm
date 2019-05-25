
local M = class("BatmanHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)
end
----
function M:_onStart()
    self.breakDownEffect = self:getEntity():getChildByName("breakDownEffect")
end
----
function M:_onHurt()
    --闪烁特效
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.Sequence:create({
        cc.Blink:create(0.1, 6),
        cc.CallFunc:create(function ()
            animationComp:getSprite():setOpacity(255)
            animationComp:getSprite():setVisible(true)
        end)
    }))

end

function M:_onDead()
    --这里代表击中,而不是对象消亡
    EffectServer.playSEXEffect({
        refNode = self:getEntity(),
        source = {"ccle_enemy_die_magic_01"}
    })
    self:destroyEntity()



    --TODO:爆道具
end

return M