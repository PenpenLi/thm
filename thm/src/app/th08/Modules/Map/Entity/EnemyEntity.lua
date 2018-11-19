module(..., package.seeall)

local M = class("EnemyEntity", MapDef.BaseEntity)
function M:ctor()
    self.speed = 0
    
end

return M