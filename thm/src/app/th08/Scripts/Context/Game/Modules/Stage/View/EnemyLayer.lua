module(..., package.seeall)
local SCENARIO_FILE_PATH_PATTERN = "Scripts.Context.Game.Modules.Stage.Scenario.Stage_%02d"
local M = {}
function M.create(params)
    -------Model-------
    local _cTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器

    
   
    -------View-------
    local node = THSTG.UI.newNode()


    

  
    -------Controller-------
    local function onInit()
        local function loadFileByid(id)
            local filePath = string.format(SCENARIO_FILE_PATH_PATTERN,id)
            return require(filePath)
        end
        
        _cTaskScheduler:setUserData({
            mapLayer = THSTG.SceneManager.get(SceneType.STAGE).entityLayer,
            danmakuLayer = THSTG.SceneManager.get(SceneType.STAGE).entityLayer,
            enemyLayer = THSTG.SceneManager.get(SceneType.STAGE).entityLayer,
        })
        _cTaskScheduler:setTasks(loadFileByid(1))

    end
    onInit()


    local function onUpdate()
        _cTaskScheduler:poll()
    end
 
    node:onNodeEvent("enter", function ()
        node:scheduleUpdateWithPriorityLua(onUpdate,0)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)
    
    return node
end

return M