
module(..., package.seeall)

local M = class("Fairy01Prefab",StageDefine.BatmanPrefab)

function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.BatmanAnimation.new()
    self:addScript(self.animationController)

    self.batmanController = StageDefine.BatmanController.new()
    self:addScript(self.batmanController)


    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)
end

----------


return M