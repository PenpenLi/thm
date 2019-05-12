module(..., package.seeall)

local M = class("WingmanPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    --精灵动画实体,这个另外一个实体
    self.spriteNode = StageDefine.BaseEntity.new()
    self.spriteNode:addComponent(StageDefine.SpriteComponent.new())
    self.spriteNode:addComponent(StageDefine.AnimationComponent.new())
    self.spriteNode:setName("SPRITE_NODE")
    self:addChild(self.spriteNode)

    self.animationController = StageDefine.WingmanAnimation.new()
    self:addScript(self.animationController)

    self.wingmanController = StageDefine.WingmanController.new()
    self:addScript(self.wingmanController)

end

----------


return M