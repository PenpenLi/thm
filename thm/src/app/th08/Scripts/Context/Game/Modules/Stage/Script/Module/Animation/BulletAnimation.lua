local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)

end

---
function M:_onStart()
    M.super._onStart(self)


end

---
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
    self.animaComp:stop()
    self.animaComp:playForever(AnimStatus.DEFAULT)
end

----

return M