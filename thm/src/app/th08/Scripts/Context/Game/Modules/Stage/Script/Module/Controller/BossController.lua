local M = class("BossController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
end


----
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "Move",  from = {"Idle","Move"},  to = "Move"},
            {name = "Idle", from = "*",  to = "Idle"},
        },
        callbacks = {
        },
    }
end
-----
function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M