module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)

    ----
    self:setName("BOSS")
    --BOSS血条
    self.healthBar = StageDefine.HealthBar.new()
    self.healthBar:setName("HEALTH_BAR")
    self:addChild(self.healthBar)
    
    self.spellController = StageDefine.EnemySpellController.new()
    self:addScript(self.spellController)
    
    self.helthController = StageDefine.BossHealth.new()
    self:addScript(self.helthController)
    ---


end

----------


return M