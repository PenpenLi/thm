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
