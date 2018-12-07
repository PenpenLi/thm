module(..., package.seeall)

local SCENARIO_FILE_PATH_PATTERN = "Scripts.Game.Modules.Stage.Scenario.StageCfg_%02d"
local M = {}
function M.create(params)
    -------Model-------
    local _uiMapLayer = require("Scripts.Game.Modules.Stage.UI.Layer.MapLayer").create()   --地图层
    local _uiEntityLayer = require("Scripts.Game.Modules.Stage.UI.Layer.EntityLayer").create()   --实体层
    local _uiScoreLayer = require("Scripts.Game.Modules.Stage.UI.Layer.ScoreLayer").create()  --分数层
    local _uiStatusLayer = require("Scripts.Game.Modules.Stage.UI.Layer.StatusLayer").create() --状态层-血条,对话框,符卡技能
    --
    local _cmpTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器



    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_uiMapLayer)
    node:addChild(_uiEntityLayer)
    node:addChild(_uiScoreLayer)
    node:addChild(_uiStatusLayer)






    -------Controller-------
    local function updateFrame()
        --敌机碰撞检测
        --擦弹什么的



        _cmpTaskScheduler:poll()
    end

    local function initScheduler()
        local function loadFileByid(id)
            local filePath = string.format(SCENARIO_FILE_PATH_PATTERN,id)
            return require(filePath)
        end
        --TODO:???
        _cmpTaskScheduler:setUserData({
            mapLayer = _uiEntityLayer,
            danmakuLayer = _uiEntityLayer,
            enemyLayer = _uiEntityLayer,
        })
        _cmpTaskScheduler:setTasks(loadFileByid(1))
    end

    node:onNodeEvent("enter", function ()
        initScheduler()
        node:scheduleUpdateWithPriorityLua(updateFrame,0)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)
    
    return node

end

return M