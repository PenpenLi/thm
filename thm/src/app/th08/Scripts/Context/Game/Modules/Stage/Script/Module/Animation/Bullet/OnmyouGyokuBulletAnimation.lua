local M = class("OnmyouGyokuBulletAnimation",StageDefine.PlayerBulletAnimation)

function M:_onInit()
    M.super._onInit(self)

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
    self:getSprite():runAction(cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_bullet_02_normal")))
end
----

return M