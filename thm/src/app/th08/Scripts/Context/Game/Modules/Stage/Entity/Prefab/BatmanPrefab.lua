module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)
   
    self.helthController = StageDefine.BatmanHealth.new()
    self:addScript(self.helthController)

    self.animationController = StageDefine.BatmanAnimation.new()
    self:addScript(self.animationController)


    self.batmanController = StageDefine.BatmanController.new()
    self:addScript(self.batmanController)

    -- debugUI(self)
end

----------


return M