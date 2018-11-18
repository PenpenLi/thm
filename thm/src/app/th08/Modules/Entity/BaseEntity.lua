module(..., package.seeall)
local EntityData = require("Models.Entity.Data.EntityData")
local M = class("BaseEntity")
function M:ctor()

    self.speed = 0          --速度
    
end

return M