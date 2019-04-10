module(..., package.seeall)

local M = class("PlayerPrefab",StageDefine.PlayerEntity)

function M:ctor(...)
    M.super.ctor(self)
    --初始化变量
    self:setName("PLAYER")

    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitterMainCtrl = self.emitter:getScript("EmitterController")
    self.emitterMainCtrl.shotInterval = 0.10
    self.emitterMainCtrl.shotSpeed = cc.p(0,20)
    self:addChild(self.emitter)

    ---
    self.healthController = StageDefine.PlayerHealth.new()
    self:addScript(self.healthController)

    self.collisionController = StageDefine.PlayerCollision.new()
    self:addScript(self.collisionController)

    self.brushController = StageDefine.BrushController.new()
    self:addScript(self.brushController)

    self.spellController = StageDefine.PlayerSpellController.new()
    self:addScript(self.spellController)

    self.inputController = StageDefine.PlayerInput.new()
    self:addScript(self.inputController)
    
    self.constraintByBorder = StageDefine.ConstraintByBorder.new()
    self:addScript(self.constraintByBorder)

    --
    self.entityCtrl.entityType = GameDef.Stage.EEntityType.Player
end


----------


return M