module(..., package.seeall)

local M = class("StageGame",StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
   
    self.schedulerComp = StageDefine.SchedulerComponent.new()
    self:addComponent(self.schedulerComp)

    --
    self.stageGameController = StageDefine.StageGameController.new()
    self:addScript(self.stageGameController)


    --
end


return M