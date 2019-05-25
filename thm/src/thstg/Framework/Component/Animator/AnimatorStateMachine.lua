local StateMachine = require "thstg.Framework.Component.Util.StateMachine"
local M = class("AnimatorStateMachine")

--状态统一处理
local function onStateProgresser(event)

end

function M:ctor()
    self._stateMachine_ = StateMachine.new()
    self._states_ = false
    self.defaultState = false
end

function M:addState(stateName)

end

function M:trans(stateName)

end

return M