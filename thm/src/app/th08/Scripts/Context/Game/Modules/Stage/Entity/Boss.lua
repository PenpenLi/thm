module(..., package.seeall)

local M = class("Boss",StageDefine.BossPrefab)
function M:ctor()
    M.super.ctor(self)

    --初始化变量
    -- self.batmanController.bulletEntity = StageDefine.EnemyBullet

    -- debugUI(self)
    self.healthBar = StageDefine.HealthBarPrefab.new()
    self.healthBar:setName("HealthBar")
    self:addChild(self.healthBar)
end


return M