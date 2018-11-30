module(..., package.seeall)
local M = class("GUIController", Controller)

function M:_onInit()
    self.__guiControllers = {
        require("Scripts.Game.Modules.GUI.MainUi.MainUiController").new(),
        require("Scripts.Game.Modules.GUI.GameUi.GameUiController").new(),
    }
end

function M:dispose()
	for _, controller in ipairs(self.__guiControllers) do
		controller:hide()
		controller:dispose()
	end
	self:super("Controller", "dispose")
end


return M