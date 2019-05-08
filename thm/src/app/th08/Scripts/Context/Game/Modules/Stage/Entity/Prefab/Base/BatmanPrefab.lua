module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)
    self:setName("BATMAN")

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    self.destroyByTime = StageDefine.DestroyByTime.new()
    self:addScript(self.destroyByTime)
   
    self.helthController = StageDefine.BatmanHealth.new()
    self:addScript(self.helthController)

end

----------


return M