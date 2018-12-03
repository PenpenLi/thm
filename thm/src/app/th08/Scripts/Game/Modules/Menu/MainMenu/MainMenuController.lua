module(..., package.seeall)
local M = class("MainMenuController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Menu.MainMenu.MainMenuView"
end

function M:_onInit()
    self:show()
end


return M