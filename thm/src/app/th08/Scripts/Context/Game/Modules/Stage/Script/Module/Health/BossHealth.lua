
local M = class("BossHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

   self._hud = nil
   self._bodyActionComp = false
end
----
function M:_onAdded()
   M.super._onAdded(self)

   self._hud = self:getEntity():findChild("HUD").uiPrgBar
end
function M:_onAwake()
   M.super._onAwake()
   self._bodyActionComp = self:getEntity():findChild("BODY/SPRITE"):getComponent("ActionComponent")
end
function M:_onHurt()
   if self._bodyActionComp then
      self._bodyActionComp:runOnce({
         cc.Blink:create(0.1, 2),
         cc.CallFunc:create(function()
            self._bodyActionComp:getEntity():setVisible(true)
         end)
      })
   end
end

function M:_onDead()
   --一个击破动画
   EffectServer.playParticle({
      refNode = self:getEntity(),
      src = ResManager.getRes(ResType.SFX,SFXType.PARTICLE,"ccp_st_boss_down"),
   })
   --震屏动画
   self:destroyEntity()

   --TODO:爆道具
end

function M:_onBlood(oldVal,newVal)
   self._hud:refresh(newVal,self:getMaxBlood())
end

return M