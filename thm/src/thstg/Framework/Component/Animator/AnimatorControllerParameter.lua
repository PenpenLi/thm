local M = class("AnimatorControllerParameter")
M.EParameterType = {
    Bool,
    Number,
    Trigger,
}
function M:ctor()
    self.type = M.EParameterType.Bool
    self.defaultValue = false
end

return M