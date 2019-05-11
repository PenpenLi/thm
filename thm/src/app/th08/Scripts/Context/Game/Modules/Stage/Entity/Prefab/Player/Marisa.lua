module(..., package.seeall)

local M = class("Marisa",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)

    ----
    self.wipeController = StageDefine.MarisaWipeController.new()
    self:addScript(self.wipeController)

    self.slowController = StageDefine.MarisaSlowController.new()
    self:addScript(self.slowController)

    self.playerController = StageDefine.MarisaController.new()
    self.playerController.roleType = GameDef.Stage.EPlayerType.Marisa
    self:addScript(self.playerController)

    
end


return M