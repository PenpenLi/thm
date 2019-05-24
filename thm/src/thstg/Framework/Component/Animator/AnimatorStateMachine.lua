local StateMachine = require "thstg.Framework.Component.Util.StateMachine"
local M = class("AnimatorStateMachine")

function M:ctor()
    self._stateMachine_ = StateMachine.new()
    self._stateMap_ = false
    self.defaultState = false
end

function M:addState(stateName,from,to)

end



return M