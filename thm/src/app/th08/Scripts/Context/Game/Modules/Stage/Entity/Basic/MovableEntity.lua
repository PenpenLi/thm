--玩家实体
module(..., package.seeall)

local M = class("MovableEntity", StageDefine.BaseEntity)
function M:ctor()
    M.super.ctor(self)
    
    self:addComponent(StageDefine.MoveComponent.new())
    self:addComponent(StageDefine.AnimationComponent.new())

end

-- function M:update()
-- 	local posComp = self:getComponent("MoveComponent")
--     self:setPosition(posComp.x,posComp.y)

--     M.super.update(self)
-- end

return M
