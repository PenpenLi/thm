module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)

    self.helthController = StageDefine.BatmanHealth.new()
    self:addScript(self.helthController)

    self.animationController = StageDefine.BatmanAnimation.new()
    self:addScript(self.animationController)
    
    debugUI(self)
   
end

----------


return M