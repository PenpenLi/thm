module(..., package.seeall)
local M = class("GameController", Controller)

function M:_initViewClass()
	return "Game.Modules.GUI.GUIModule"
end

function M:_onInit()


end

return M