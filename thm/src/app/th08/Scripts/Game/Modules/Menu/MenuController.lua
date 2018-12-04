module(..., package.seeall)
local M = class("MenuController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Menu.MenuView"
end

function M:_onInit()
    self.__menuControllers = {
        require("Scripts.Game.Modules.Menu.MainMenu.MainMenuController").new(),
    }
end


function M:dispose()
	for _, controller in ipairs(self.__menuControllers) do
		controller:hide()
		controller:dispose()
	end
	self.super.dispose(self)
end

return M