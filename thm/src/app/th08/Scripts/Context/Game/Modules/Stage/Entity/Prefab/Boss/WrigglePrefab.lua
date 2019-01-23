module(..., package.seeall)

local M = class("WrigglePrefab",StageDefine.BossPrefab)

function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.WriggleAnimation.new()
    self:addScript(self.animationController)

    self.bossController = StageDefine.WriggleController.new()
    self:addScript(self.bossController)

    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)
end

----------


return M