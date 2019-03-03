local M = class("BatmanController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.batmanType = Const.Stage.EBatmanType.Fairy01
end
----
function M:_onStart()
    M.super._onStart(self)
    local healthCtrl = self:getScript("HealthController")
    healthCtrl:reset(10)
end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M