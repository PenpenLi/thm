local M = class("ReimuBulletAnimation",StageDefine.PlayerBulletAnimation)

function M:_onInit()
    M.super._onInit(self)
    --
    self.rotation = -90
    self.centerPoint = cc.p(0.875,0.5)
end
--

---
function M:_onStart()
    M.super._onStart(self)
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

function M:_onIdle(event)
    self:getSprite():runAction(cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_bullet_01_normal")))
end
----

return M