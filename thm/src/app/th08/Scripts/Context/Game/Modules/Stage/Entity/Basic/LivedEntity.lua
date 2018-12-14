--玩家实体
module(..., package.seeall)

local M = class("LivedEntity", StageDefine.MovableEntity)
function M:ctor()
    M.super.ctor(self)
    self:addComponent(StageDefine.LifeComponent.new())
    self:addComponent(StageDefine.RigidbodyComponent.new())

end

return M
