module(..., package.seeall)
local BaseEntity = require("Models.Entity.BaseEntity")
local M = class("EnemyEntity", BaseEntity)
function M:ctor()
    self.speed = 0          --速度
    
end

return M