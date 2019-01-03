module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)

    self.batmanController = StageDefine.BatmanController.new()
    self:addScript(self.batmanController)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)
   
    self.helthController = StageDefine.BatmanHealth.new()
    self:addScript(self.helthController)

    -- debugUI(self)
end

----------


return M