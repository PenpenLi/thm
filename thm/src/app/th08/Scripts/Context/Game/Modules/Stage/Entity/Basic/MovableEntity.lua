--玩家实体
module(..., package.seeall)

local M = class("MovableEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    

    self:addComponent(StageDefine.AnimationComponent.new())

end

return M
