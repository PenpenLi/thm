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

    --精灵动画实体,这个另外一个实体,不会影响到两个僚机
    self.spriteNode = StageDefine.BaseEntity.new()
    self.spriteNode:addComponent(StageDefine.SpriteComponent.new())
    self.spriteNode:addComponent(StageDefine.AnimationComponent.new())
    self.spriteNode:setName("SPRITE_NODE")
    self:addChild(self.spriteNode)

    self.animationController = StageDefine.PlayerAnimation.new()
    self.spriteNode:addScript(self.animationController)
    
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

end


----------


return M