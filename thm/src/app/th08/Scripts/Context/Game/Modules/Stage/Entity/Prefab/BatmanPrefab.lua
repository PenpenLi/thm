module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)

    self.batmanController = StageDefine.BatmanController.new()
    self:addScript(self.batmanController)

    self.destoryByBorder = StageDefine.DestoryByBorder.new()
    self:addScript(self.destoryByBorder)
   
    debugUI(self)
end

----------


return M