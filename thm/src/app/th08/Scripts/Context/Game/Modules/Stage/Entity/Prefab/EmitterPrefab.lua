module(..., package.seeall)

local M = class("EmitterPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)
    self:setName("EMITTER")

    self.emitterController = StageDefine.EmitterController.new()
    self:addScript(self.emitterController)

end

----------


return M