
local M = class("StageGameController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)
    
    self._cTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器
    self._ePlayer = StageDefine.Player.new()


    ---
    self._ePlayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)

end

function M:updateStage()
    --TODO:根据关卡改变
    local stageID = Cache.stageCache.getStageId()
    self._cTaskScheduler:setTasks(StageConfig.getScenario(stageID))

    local map = StageConfig.getMap(1).create()
    map:addTo(THSTG.SceneManager.get(SceneType.STAGE).backgroundLayer)
end

function M:_onStart()
    M.super._onStart(self)
    self:updateStage()

end

function M:_onUpdate()
    self._cTaskScheduler:poll()
end



return M