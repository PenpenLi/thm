
--实体基类
module(..., package.seeall)

local M = class("LivedEntityData", EntityDef.EntityData)

function M:ctor()
    self._speed = 0
end

return M