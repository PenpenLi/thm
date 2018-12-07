
--实体基类
module(..., package.seeall)

local M = class("LivedEntityData", StageDefine.EntityData)

function M:ctor()
    self._speed = StageDefine.Speed.new()          --速度
    self._rigidBody = StageDefine.Rigidbody.new()  --碰撞矩形
end

return M