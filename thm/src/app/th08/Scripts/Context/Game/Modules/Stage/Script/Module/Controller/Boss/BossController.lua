local M = class("BossController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.bossType = BossType.WRIGGLE_NIGHTBUG
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
function M:_onStart()
    M.super._onStart(self)

    local healthCtrl = self:getScript("HealthController")
    healthCtrl:reset(1000)
end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M