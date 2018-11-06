--玩家实体
module(..., package.seeall)
local BaseEntity = require("Models.Entity.BaseEntity")
local M = class("PlayerEntity", BaseEntity)
function M:ctor()
end

return M
