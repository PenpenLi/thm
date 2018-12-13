--玩家实体
module(..., package.seeall)

local M = class("LivedEntity", StageDefine.BaseEntity)
function M:_onInit()
    self.super._onInit(self)
end


return M
