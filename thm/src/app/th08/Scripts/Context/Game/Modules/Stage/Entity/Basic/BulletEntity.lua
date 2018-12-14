module(..., package.seeall)

local M = class("BulletEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
end

return M
