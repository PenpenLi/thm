module(..., package.seeall)

local M = class("BossEntity", StageDefine.EnemyEntity)
function M:ctor()
    M.super.ctor(self)
    
end

return M