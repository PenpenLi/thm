local AnimatorStateMechine = require("thstg.Framework.Component.Animator.AnimatorStateMachine")
local M = class("AnimatorController")

--从文件中加载控制器
function M.loadController(ctrlPath,bindMap)

end
---
function M:ctor()
    self._stateMachine_ = AnimatorStateMechine.new()
    self._paramterMap_ = false
end

function M:addParameter(parameter)

end

function M:addMotion(stateName)
    --直接在AnimationCache中获取
end

return M