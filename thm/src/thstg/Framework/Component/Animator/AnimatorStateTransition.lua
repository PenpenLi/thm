local AnimatorStateTransitionCondition = require "thstg.Framework.Component.Animator.AnimatorStateTransitionCondition"
local M = class("AnimatorStateTransition")

function M:ctor()
    self._conditions_ = false
    self.hasExitTime = false
end

function M:addCondition(conditionMode, paramterName)
    local condition = AnimatorStateTransitionCondition.new()
    condition.name = paramterName
    condition.mode = conditionMode

    self._conditions_ = self._conditions_ or {}
    self._conditions_[condition] = condition

    return condition
end

function M:_isAccord(valueList)
    --是否满足其中一个条件

    return false
end

return M