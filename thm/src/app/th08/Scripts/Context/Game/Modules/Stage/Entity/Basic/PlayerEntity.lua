--玩家实体
module(..., package.seeall)

local M = class("PlayerEntity", StageDefine.LivedEntity)
function M:ctor(...)
    M.super.ctor(self)
    self:addComponent(StageDefine.InputComponent.new())

    --精灵动画实体
    self.spriteNode = StageDefine.BaseEntity.new()
    self.spriteNode:addComponent(StageDefine.SpriteComponent.new())
    self.spriteNode:addComponent(StageDefine.AnimationComponent.new())
    self.spriteNode:setName("SPRITE_NODE")
    self:addChild(self.spriteNode)
end


------


return M
