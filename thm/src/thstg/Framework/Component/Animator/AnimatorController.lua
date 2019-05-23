local M = class("AnimatorController")

function M.loadController(ctrlPath,bindMap)
end
---
function M:ctor()
    self._stateMachine_ = false
    self._paramterMap_ = false
end

function M:addParameter(parameter)

end

function M:addMotion(motion)

end

return M