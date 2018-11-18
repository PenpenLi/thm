--实体基类
module(..., package.seeall)
local M = class("EntityData")

function M:ctor()
    self._collisionRect = false --碰撞矩形
end


return M