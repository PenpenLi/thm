
local M = class("BossHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

   self._hud = nil
end
----
function M:_onAdded()
   M.super._onAdded(self)

   self._hud = self:getEntity():findChild("HUD").uiPrgBar
end

function M:_onHurt()

   local animationComp = self:getEntity():findChild("BODY").sprite:getComponent("AnimationComponent")
   animationComp:playOnce({
      cc.Blink:create(0.1, 2),
      cc.CallFunc:create(function()
         animationComp:getSprite():setVisible(true)
      end)
   })
   
end

function M:_onDead()
   --一个击破动画
   EffectServer.playParticle({
      refNode = self:getEntity(),
      src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_st_boss_down"),
   })

   self:destroyEntity()

   --TODO:爆道具
end

function M:_onBlood(oldVal,newVal)
   self._hud:refresh(newVal,self:getMaxBlood())
end

return M