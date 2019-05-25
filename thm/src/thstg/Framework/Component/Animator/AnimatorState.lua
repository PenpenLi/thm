local AnimatorStateTransition = require("thstg.Framework.Component.Animator.AnimatorStateTransition")
local M = class("AnimatorState")

local function createTransNode(otherState)
    return {
        
        toState = otherState,
    }
end
function M:ctor()
    self.tag = false

    self.motion = false
    self.speed = false
    self.mirror = false
    self.normalizeTime = false

    self._transitions_ = false
    self._name_ = false
end

function M:addTransition(otherState)
    local transion = AnimatorStateTransition.new()


    return transion
end

return M