module(..., package.seeall)
local M = class("MainUIController", Controller)

function M:_initViewClass()
    return "Scripts.Context.Game.Modules.MainUI.MainUIView"
end

function M:_onInit()
	Dispatcher.addEventListener(EventType.PUBLIC_OPEN_MODULE, self.__openModuleHandler, self)
	Dispatcher.addEventListener(EventType.PUBLIC_CLOSE_MODULE, self.__closeModuleHandler, self)
end

function M:__openModuleHandler(e, moduleType, ...)
	ModuleManager.open(moduleType, ...)
end

function M:__closeModuleHandler(e, moduleType, ...)
	ModuleManager.close(moduleType, ...)
end

return M