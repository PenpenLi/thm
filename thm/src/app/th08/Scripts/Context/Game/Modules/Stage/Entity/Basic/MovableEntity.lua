--玩家实体
module(..., package.seeall)

local M = class("MovableEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.SpriteComponent.new())
    self:addComponent(StageDefine.AnimationComponent.new())
    -- self:addComponent(StageDefine.RigidbodyComponent.new())
    self:addComponent(StageDefine.BoxColliderComponent.new())

end

return M
