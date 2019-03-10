
local M = class("StageGameController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)
    
    --
    self._ePlayer = false
end

function M:initStage()
    local stageID = Cache.stageCache.getStageId()
    local schedulerComp = self:getComponent("SchedulerComponent")
    schedulerComp:setTasks(StageConfig.getScenario(stageID))

    local map = StageConfig.getMap(stageID).create()
    map:addTo(THSTG.SceneManager.get(SceneType.STAGE).backgroundLayer)
end

function M:initPlayer()
    local roleType = Cache.stageCache.getRoleType()
    self._ePlayer = EntityManager.createPlayer(roleType)

    self._ePlayer:getScript("PlayerController"):reset()
end

function M:_onStart()
    M.super._onStart(self)

    self:initPlayer()
    self:initStage()
end

function M:_onUpdate()
   
end



return M