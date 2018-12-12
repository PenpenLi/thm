module(..., package.seeall)
local M = class("SelectController", Controller)

function M:_initViewClass()
    return "Scripts.Context.Game.Modules.Role.Selection.SelectionView"
end

function M:_onInit()

end

return M