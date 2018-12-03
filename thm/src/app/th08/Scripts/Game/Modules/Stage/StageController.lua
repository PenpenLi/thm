module(..., package.seeall)
local M = class("StageController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Stage.StageView"
end

function M:_onInit()
    THSTG.Dispatcher.addEventListener(EventType.STAGE_ENTER, self.__enterSection, self)
    -- self:show()
end

function M:__enterSection(e,params)
    self:show(params)
end

return M