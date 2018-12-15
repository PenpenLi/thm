module(..., package.seeall)

local M = class("BaseEntity",THSTG.ECS.Entity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.PositionComponent.new())
end



------------------------------------------------------------------

return M