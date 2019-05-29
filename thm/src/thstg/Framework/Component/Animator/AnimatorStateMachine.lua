local StateMachine = require "thstg.Framework.Component.Util.StateMachine"
local M = class("AnimatorStateMachine")

--状态统一处理
local function onStateProgresser(event)

end

function M:_init()
    --默认的几个状态[Any State,Enter,Exit]
end

function M:ctor()
    self._stateMachine_ = StateMachine.new()
    self._states_ = false
    self._curState = false
    self._nextState = false

    self.defaultState = false

    self:_init()
end

function M:addState(stateName)

end

function M:trans(stateName)

end

function M:_onStateHandler(event)
    
end

return M