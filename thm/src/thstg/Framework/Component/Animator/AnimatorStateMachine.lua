local SteteMachine =  require "thstg.Framework.Component.Util.StateMachine"
local M = class("AnimatorStateMachine")

function M:ctor()
    self._stateMachine_ = SteteMachine.new()
    self._stateMap_ = false
    self.defaultState = false
end

function M:addState(stateName)

end

return M