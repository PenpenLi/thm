--玩家实体
module(..., package.seeall)

local M = class("MovableEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.SpriteComponent.new())
    self:addComponent(StageDefine.AnimationComponent.new())
    
    local rigidbodyComponent = StageDefine.RigidbodyComponent.new()
    rigidbodyComponent:setGravityEnabled(false)
    self:addComponent(rigidbodyComponent)

    self:addComponent(StageDefine.BoxColliderComponent.new())

    --精灵动画实体
    self.spriteNode = StageDefine.BaseEntity.new()
    self.spriteNode:addComponent(StageDefine.SpriteComponent.new())
    self.spriteNode:addComponent(StageDefine.AnimationComponent.new())
    self.spriteNode:setName("SPRITE_NODE")
    self:addChild(self.spriteNode)

    ---XXX:TEST
    -- local ccrigibbodyComp = THSTG.ECS.CCRigidbodyComponent.new()
    -- ccrigibbodyComp:setGravityEnable(false)
    -- self:addComponent(ccrigibbodyComp)
    
    -- local boxCollider = THSTG.ECS.CCBoxColliderComponent.new({
    --     size = cc.size(16,16)
    -- })
    -- boxCollider:setSensor(true)
    -- self:addComponent(boxCollider)
end

return M
