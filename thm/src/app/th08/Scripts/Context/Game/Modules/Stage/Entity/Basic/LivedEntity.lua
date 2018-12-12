--玩家实体
module(..., package.seeall)

local M = class("LivedEntity", StageDefine.BaseEntity)
function M:ctor()

    local function frameUpdateHandler(dt)
		self:_onUpdate(dt)
	end
	self:scheduleUpdateWithPriorityLua(frameUpdateHandler, 0)
end

------

function M:_onUpdate(dt)
    
end


return M
