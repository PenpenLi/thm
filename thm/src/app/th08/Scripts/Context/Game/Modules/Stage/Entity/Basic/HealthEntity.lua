module(..., package.seeall)

local M = class("HealthEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
end

return M