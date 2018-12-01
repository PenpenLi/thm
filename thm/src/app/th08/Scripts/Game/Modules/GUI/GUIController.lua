module(..., package.seeall)
local M = class("GUIController", Controller)

function M:_onInit()
    self.__guiControllers = {
        require("Scripts.Game.Modules.GUI.MainUI.MainUIController").new(),
        require("Scripts.Game.Modules.GUI.GameUI.GameUIController").new(),
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