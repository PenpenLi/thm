module(..., package.seeall)

local M = class("PlayerPrefab",StageDefine.PlayerEntity)

function M:ctor(...)
    M.super.ctor(self)

    self.healthController = StageDefine.PlayerHealth.new()
    self:addScript(self.healthController)

    self.collisionController = StageDefine.PlayerCollision.new()
    self:addScript(self.collisionController)

    self.inputController = StageDefine.PlayerInput.new()
    self:addScript(self.inputController)
    
    self.animationController = StageDefine.PlayerAnimation.new()
    self:addScript(self.animationController)

    self.constraintByBorder = StageDefine.ConstraintByBorder.new()
    self:addScript(self.constraintByBorder)

    self.playerController = StageDefine.PlayerController.new()
    self:addScript(self.playerController)

end


----------


return M