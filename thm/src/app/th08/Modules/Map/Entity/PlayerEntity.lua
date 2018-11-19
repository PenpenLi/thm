--玩家实体
module(..., package.seeall)

local M = class("PlayerEntity", MapDef.BaseEntity)
function M:ctor()
    -- self.roleType = false   --人物类型
    self.speed = 0          --速度
    
end

return M
