module(..., package.seeall)

local M = class("BossEntity", StageDefine.EnemyEntity)
function M:_onInit()
    self.super._onInit(self)
end

return M