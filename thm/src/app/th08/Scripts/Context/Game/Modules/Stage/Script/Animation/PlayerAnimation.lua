local M = class("PlayerAnimation",StageDefine.AnimationController)

function M:_onInit()

end

function M:play(actionType)
    local roleType = Cache.roleCache.getType()
    M.super.play(self,roleType,actionType)

end

----

return M