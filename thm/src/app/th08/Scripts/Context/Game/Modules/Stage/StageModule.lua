module(..., package.seeall)

local M = class("StageModule", THSTG.CORE.Module)

function M:_onView()

    --自机层
    self._playerLayer = require("Scripts.Context.Game.Modules.Stage.View.PlayerLayer").create()
    self._playerLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)

    --敌机层
    self._enemyLayer = require("Scripts.Context.Game.Modules.Stage.View.EnemyLayer").create()
    self._enemyLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)

end

function M:_onInit()
    
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_ENTER, self.__enterStage, self)
    -- THSTG.Dispatcher.addEventListener(EventType.STAGE_EXIT, self.__exitStage, self)

end




return M