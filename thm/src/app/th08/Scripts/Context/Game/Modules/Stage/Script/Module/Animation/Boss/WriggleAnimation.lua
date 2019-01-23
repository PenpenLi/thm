local M = class("BossAnimation",StageDefine.BossAnimation)

function M:_onInit()
    M.super._onInit(self)
end
---
function M:_onStart()
    M.super._onStart(self)
end

function M:_onState()
    return M.super._onState(self)
end
---
return M