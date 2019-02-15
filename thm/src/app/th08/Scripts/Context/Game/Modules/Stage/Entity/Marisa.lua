module(..., package.seeall)

local M = class("Marisa",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.PlayerAnimation.new()
    self.spriteNode:addScript(self.animationController)

    self.wipeController = StageDefine.MarisaWipeController.new()
    self:addScript(self.wipeController)

    self.slowController = StageDefine.MarisaSlowController.new()
    self:addScript(self.slowController)

    self.playerController = StageDefine.MarisaController.new()
    self.playerController.roleType = RoleType.Marisa
    self:addScript(self.playerController)

    ---
    local shotCtrl = self.emitter:getScript("EmitterController")
    shotCtrl.objectPrefab = StageDefine.MarisaBulletPrefab

    ---
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)  
end


return M