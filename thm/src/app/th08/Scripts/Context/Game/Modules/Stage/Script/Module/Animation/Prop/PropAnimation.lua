local M = class("PropAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

---
function M:getBossType()
    return self.propType
end

function M:_onStart()
    M.super._onStart(self)

    local propControScript = self:getScript("PropController")
    self.propType = propControScript.propType
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
---
function M:_onIdle(event)
  
end
---
return M