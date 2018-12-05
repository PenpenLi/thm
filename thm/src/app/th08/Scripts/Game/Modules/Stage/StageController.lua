module(..., package.seeall)

local M = class("StageController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Stage.StageView"
end

function M:_onInit()
    THSTG.Dispatcher.addEventListener(EventType.STAGE_ENTER, self.__enterStage, self)
    THSTG.Dispatcher.addEventListener(EventType.STAGE_EXIT, self.__exitStage, self)

    self.__systemControllers = {
        require("Scripts.Game.Modules.Stage.System.SpellCard.SpellCardController").new(),
    }
end

function M:dispose()
	for _, controller in ipairs(self.__systemControllers) do
		controller:hide()
		controller:dispose()
	end
	self.super.dispose(self)
end

function M:__enterStage(e,params)

end

function M:__exitStage(e,params)


end

return M