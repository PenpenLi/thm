local M = class("AnimatorControllerParameter")
M.EParameterType = {
    Bool,
    Number,
    Trigger,
}
function M:ctor()
    self.type = false
    self.defaultValue = false
end

return M