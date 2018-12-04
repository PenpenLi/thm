module(..., package.seeall)
local M = class("MainUIController", Controller)

function M:_onInit()
	THSTG.Dispatcher.addEventListener(EventType.PUBLIC_OPEN_MODULE, self.__openModuleHandler, self)
	THSTG.Dispatcher.addEventListener(EventType.PUBLIC_CLOSE_MODULE, self.__closeModuleHandler, self)
end

function M:__openModuleHandler(e, moduleType, ...)
	local check = self._checkLevelModule[moduleType]
	if check then
		if not GuideConfig.isOpen(check.key) then
			if check.tip then
			else
				MsgManager.showRollTipsMsg(Language.getString(100010))
			end
			return
		end
	end
	ModuleManager.open(moduleType, ...)
end

function M:__closeModuleHandler(e, moduleType, ...)
	ModuleManager.close(moduleType, ...)
end

return M