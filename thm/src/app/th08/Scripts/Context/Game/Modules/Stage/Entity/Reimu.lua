module(..., package.seeall)

local M = class("Reimu",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.ReimuAnimation.new()
    self.spriteNode:addScript(self.animationController)

    self.wipeController = StageDefine.ReimuWipeController.new()
    self:addScript(self.wipeController)

    self.slowController = StageDefine.ReimuSlowController.new()
    self:addScript(self.slowController)

    self.playerController = StageDefine.ReimuController.new()
    self:addScript(self.playerController)

    --添加两个僚机的实体
    self.gyoku1 = StageDefine.OnmyouGyoku.new()
    self.gyoku1:setName("GYOKU1")
    self:addChild(self.gyoku1)

    self.gyoku2 = StageDefine.OnmyouGyoku.new()
    self.gyoku2:setName("GYOKU2")
    self:addChild(self.gyoku2)

    ---
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)  
end


return M