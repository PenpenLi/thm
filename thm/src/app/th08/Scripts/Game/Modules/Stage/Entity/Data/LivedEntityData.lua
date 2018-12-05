
--实体基类
module(..., package.seeall)

local M = class("LivedEntityData", StageDef.EntityData)

function M:ctor()
    self._speed = StageDef.Speed.new()          --速度
    self._rigidBody = StageDef.Rigidbody.new()  --碰撞矩形
end

return M