module(..., package.seeall)
local M = class("MenuController", Controller)

function M:_onInit()
    self.__menuControllers = {
        require("Scripts.Game.Modules.Menu.MainMenu.MainMenuController").new(),
    }
end


return M