
local M = class("BossHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

   self.blood = 10000

   self._healthBarController = nil
end
----
function M:_onStart()
   M.super._onStart(self)
   local entity = self:getEntity():getChildByName("HealthBar")
   self._healthBarController = entity:getScript("HealthBarController")
end

function M:_onHurt()
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
   --一个击破动画
   GlobalUtil.playParticle({
      refNode = self:getEntity(),
      src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_st_boss_down"),
   })

   self:killEntity()

   --TODO:爆道具
end

function M:_onBlood(oldVal,newVal)
   self._healthBarController:refresh(newVal,10000)
end

return M