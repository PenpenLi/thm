local M = class("AnimatorStateTransitionCondition")
M.Mode = {
    If,
    IfNot,
}
function M:ctor()
    self.name = M.Mode.If
    self.mode = false
end

return M