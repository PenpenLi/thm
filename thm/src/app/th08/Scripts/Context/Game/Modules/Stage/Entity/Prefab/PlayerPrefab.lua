module(..., package.seeall)

local M = class("PlayerPrefab",StageDefine.PlayerEntity)

function M:ctor(...)
    M.super.ctor(self)

    self.playerController = StageDefine.PlayerController.new()
    self:addScript(self.playerController)
    
    self.playerCollision = StageDefine.PlayerCollision.new()
    self:addScript(self.playerCollision)

    ---

end


----------


return M