module(..., package.seeall)

local M = class("StageModule", THSTG.CORE.Module)

function M:_initView()
    local layer = require("Scripts.Context.Game.Modules.Stage.View.StageGameUI").create()
    layer:addTo(THSTG.SceneManager.getScene(SceneType.STAGE))
end

function M:_onInit()
    self:_initView()
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_ENTER, self.__enterStage, self)
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_EXIT, self.__exitStage, self)

    
end




return M