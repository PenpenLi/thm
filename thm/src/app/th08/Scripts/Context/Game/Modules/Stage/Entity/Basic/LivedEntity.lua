--玩家实体
module(..., package.seeall)

local M = class("LivedEntity", StageDefine.MovableEntity)
function M:ctor()
    M.super.ctor(self)
    
end

return M
