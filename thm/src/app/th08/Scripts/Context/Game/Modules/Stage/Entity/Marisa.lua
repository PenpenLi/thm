module(..., package.seeall)

local M = class("Marisa",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)

    ----
    self.emitterMainCtrl.objectPrefab = StageDefine.MarisaBulletPrefab
    ----
    self.animationController = StageDefine.PlayerAnimation.new()
    self.spriteNode:addScript(self.animationController)

    self.wipeController = StageDefine.MarisaWipeController.new()
    self:addScript(self.wipeController)

    self.slowController = StageDefine.MarisaSlowController.new()
    self:addScript(self.slowController)

    self.playerController = StageDefine.MarisaController.new()
    self.playerController.roleType = GameDef.Stage.ERoleType.Marisa
    self:addScript(self.playerController)

end


return M