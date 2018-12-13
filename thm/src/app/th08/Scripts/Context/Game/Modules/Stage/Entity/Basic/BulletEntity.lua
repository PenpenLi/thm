module(..., package.seeall)

local M = class("BulletEntity", StageDefine.BaseEntity)
function M:_onInit()
    self.super._onInit(self)
end

return M
