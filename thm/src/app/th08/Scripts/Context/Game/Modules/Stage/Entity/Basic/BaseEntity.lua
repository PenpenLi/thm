module(..., package.seeall)

local M = class("BaseEntity",StageDefine.EmptyEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.ActionComponent.new())
end



------------------------------------------------------------------

return M