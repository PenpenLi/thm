module(..., package.seeall)

local M = class("BaseEntity",THSTG.ECS.CCEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.TransformComponent.new())
    self:addComponent(StageDefine.ActionComponent.new())
end



------------------------------------------------------------------

return M