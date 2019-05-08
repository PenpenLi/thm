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
    self.playerController.roleType = GameDef.Stage.ERoleType.Marisa
    self:addScript(self.playerController)

    --
    self.entityData:setDataByCode(10100002)
    
end


return M