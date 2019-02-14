module(..., package.seeall)

local M = class("EmptyEntity",THSTG.ECS.Entity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.TransformComponent.new())
end



------------------------------------------------------------------

return M