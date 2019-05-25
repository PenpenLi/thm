local AnimatorStateMechine = require("thstg.Framework.Component.Animator.AnimatorStateMachine")
local AnimatorState = require("thstg.Framework.Component.Animator.AnimatorState")
local AnimatorControllerParameter = require("thstg.Framework.Component.Animator.AnimatorControllerParameter")
local M = class("AnimatorController")

--从文件中加载控制器
function M.loadController(ctrlPath,bindMap)
    local controller = AnimatorController.new()

    return controller
end
---
function M:ctor()
    self._stateMachine_ = AnimatorStateMechine.new()
    self._paramters_ = false
end

function M:addParameter(parameter)
    local parameter = AnimatorControllerParameter.new()

    self._paramters_ = self._paramters_ or {}
    self._paramters_[parameter] = parameter

    return parameter
end

function M:addMotion(motion)
    --直接在AnimationCache中获取
    local state = AnimatorState.new()
    self._stateMachine_:addState(stateName)


    return state
end

return M