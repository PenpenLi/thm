module(..., package.seeall)

local M = class("BaseEntity",THSTG.ECS.Entity)
function M:ctor()
    M.super.ctor(self)
    ----
	self:addComponent(StageDefine.TransformComponent.new())
    self:addComponent(StageDefine.ActionComponent.new())
    

    self.entityData = StageDefine.EntityBasedata.new()
    self:addScript(self.entityData)
    self.entityCtrl = StageDefine.EntityController.new()
    self:addScript(self.entityCtrl)


end



------------------------------------------------------------------

return M