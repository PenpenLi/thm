--玩家实体
module(..., package.seeall)

local M = class("PlayerEntity", StageDefine.LivedEntity)
function M:ctor(...)
    M.super.ctor(self)
    self:addComponent(StageDefine.InputComponent.new())


end


------


return M
