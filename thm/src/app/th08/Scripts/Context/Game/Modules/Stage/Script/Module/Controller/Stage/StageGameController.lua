
local M = class("StageGameController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)
    
    --
    self._ePlayer = false
end

function M:initStage()
    --FIXME:根据关卡改变
    local stageID = Cache.stageCache.getStageId()
    local schedulerComp = self:getComponent("SchedulerComponent")
    schedulerComp:setTasks(StageConfig.getScenario(stageID))

    local map = StageConfig.getMap(stageID).create()
    map:addTo(THSTG.SceneManager.get(SceneType.STAGE).backgroundLayer)
end

function M:initPlayer()
    --FIXME:根据ERoleType变动
    self._ePlayer = StageDefine.Reimu.new()
    self._ePlayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)  

end

function M:_onStart()
    M.super._onStart(self)

    self:initPlayer()
    self:initStage()
end

function M:_onUpdate()
   
end



return M