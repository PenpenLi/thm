module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)

    ----
    self:setName("BOSS")
    
    
    self.helthController = StageDefine.BossHealth.new()
    self:addScript(self.helthController)

end

----------


return M