module(..., package.seeall)

local M = class("StageGame",StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
   
    self.stageGameController = StageDefine.StageGameController.new()
    self:addScript(self.stageGameController)

end


return M