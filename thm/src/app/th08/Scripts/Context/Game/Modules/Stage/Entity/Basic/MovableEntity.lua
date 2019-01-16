--玩家实体
module(..., package.seeall)

local M = class("MovableEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.SpriteComponent.new())
    self:addComponent(StageDefine.AnimationComponent.new())
    
    local rigidbodyComponent = StageDefine.RigidbodyComponent.new()
    rigidbodyComponent.gravityScale = 0
    self:addComponent(rigidbodyComponent)

    self:addComponent(StageDefine.BoxColliderComponent.new())

end

return M
