
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
   --TODO:受伤频闪引发的bug,前后2次调用的时间差小于行为执行的时间差
   if self._isBlink ~= true then
      self._isBlink = true
      local animationComp = self:getComponent("AnimationComponent")
      animationComp:play(cc.Sequence:create({
         cc.Blink:create(0.1, 2),
         cc.CallFunc:create(function ()
            self._isBlink = false
         end)
      }))
   end
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