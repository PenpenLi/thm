--玩家实体
module(..., package.seeall)

local M = class("PlayerEntity", StageDefine.LivedEntity)

function M:ctor()
    self._state = false

end
------

function M:__inputHandle(input)
    -- local newState = self._state:input(self,input)
    -- if newState then
    --     self._state = newState
    --     newState:enter(self)
    -- end
end

function M:_onUpdate(dt)
    -- self:__inputHandle()
end

return M
