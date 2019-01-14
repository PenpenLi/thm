module(..., package.seeall)

local M = {}
function M.create(params)
    -----
    local _viewPlayerLayer = require("Scripts.Context.Game.Modules.Stage.View.PlayerLayer").create()
    local _viewEnemyLayer = require("Scripts.Context.Game.Modules.Stage.View.EnemyLayer").create()

    local _eStageGame = StageDefine.StageGame.new()


    local _cTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器
    -----
    local node = THSTG.UI.newNode()
    node:addChild(_eStageGame)

    _viewPlayerLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)
    _viewEnemyLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)


    -------Controller-------
    local function onInit()        
       
    end

    local function onUpdate()
        _cTaskScheduler:poll()
    end
 
    node:onNodeEvent("enter", function ()
        node:scheduleUpdateWithPriorityLua(onUpdate,0)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)



    onInit()
    return node
end

return M