local M = class("AnimatorStateTransition")
M.EConditionMode = {
    If,
    IfNot,
}
function M:ctor()
    self._conditions_ = false
    self.hasExitTime = false
end

function M:addCondition(conditionMode, paramterName)

end

return M