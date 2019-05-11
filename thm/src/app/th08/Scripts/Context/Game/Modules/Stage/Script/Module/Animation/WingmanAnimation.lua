local M = class("WingmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "Idle", from = {},  to = "Idle"},
        },
        callbacks = {
            onIdle = handler(self,self._onIdle),
        },
    }
end

----
function M:_onStart()
    M.super._onStart(self)
  
    --重定向组件
    self.animaComp = self:getEntity():getChildByName("SPRITE_NODE"):getComponent("AnimationComponent")
    self.spriteComp = self:getEntity():getChildByName("SPRITE_NODE"):getComponent("SpriteComponent")
end

function M:_onIdle(event)
    self.animaComp:stop()
    self.animaComp:playForever(AnimStatus.DEFAULT)
end

----


return M