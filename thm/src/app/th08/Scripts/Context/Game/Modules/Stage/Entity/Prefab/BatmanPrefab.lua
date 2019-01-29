module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    self.destroyByTime = StageDefine.DestroyByTime.new()
    self:addScript(self.destroyByTime)
   
    self.helthController = StageDefine.BatmanHealth.new()
    self:addScript(self.helthController)

    self.animationController = StageDefine.BatmanAnimation.new()
    self:addScript(self.animationController)


    self.batmanController = StageDefine.BatmanController.new()
    self:addScript(self.batmanController)

    --
    self:setName("BATMAN")
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)
end

----------


return M