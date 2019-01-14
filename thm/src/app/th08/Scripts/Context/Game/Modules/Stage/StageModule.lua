module(..., package.seeall)

local M = class("StageModule", THSTG.CORE.Module)

function M:_onView()
    local view = require("Scripts.Context.Game.Modules.Stage.View.StageView").create()
    view:addTo(THSTG.SceneManager.get(SceneType.STAGE))
    return view
end

function M:_onInit()
    
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_ENTER, self.__enterStage, self)
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_EXIT, self.__exitStage, self)

end




return M