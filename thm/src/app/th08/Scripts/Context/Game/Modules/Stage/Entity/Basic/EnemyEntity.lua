module(..., package.seeall)

local M = class("EnemyEntity", StageDefine.LivedEntity)
function M:_onInit()
    self.super._onInit(self)
end

return M