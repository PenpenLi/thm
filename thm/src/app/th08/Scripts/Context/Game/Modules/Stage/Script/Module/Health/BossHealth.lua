
local M = class("BossHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

   --BOSS血条
   self._healthBar = THSTG.UI.newRadialProgressBar({
      x = 0,
      y = 0, --半径
      anchorPoint = THSTG.UI.POINT_CENTER,
      isReverse = true,
      minValue = 0,
      maxValue = 50,
      offset = 90,
      style = {
          --背景皮肤
          bgSkin = false,
          --进度条皮肤
          progressSkin = {
              src = ResManager.getUIRes(UIType.PROGRESS_BAR, "prog_radial_boss_hp"),
          }
      }
  })

end
----
function M:_onAdded()
   M.super._onAdded(self)

   self._healthBar:setPosition(cc.p(self:getEntity():getContentSize().width/2,self:getEntity():getContentSize().height/2))
   self:getEntity():addChild(self._healthBar)
end

function M:_onHurt()
   --TODO:受伤频闪引发的bug,前后2次调用的时间差小于行为执行的时间差
   local animationComp = self:getComponent("AnimationComponent")
   animationComp:play(cc.Sequence:create({
      cc.Blink:create(0.1, 2),
      cc.CallFunc:create(function()
         animationComp:getSprite():setVisible(true)
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
   self._healthBar:refresh(newVal,self:getMaxBlood())
end

return M