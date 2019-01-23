local M = class("BossController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.bossType = nil
end


return M