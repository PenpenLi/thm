
--实体基类
module(..., package.seeall)

local M = class("LivedEntityData", StageDef.EntityData)

function M:ctor()
    self._speed = StageDef.Speed.new()
end

return M