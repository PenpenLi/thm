
local M = class("StageGameController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)
    
    --
    self._ePlayer = false
end

function M:initStage()
    local stageID = ModuleCache.Stage:getStageId()
    local schedulerComp = self:getComponent("SchedulerComponent")
    schedulerComp:setTasks(StageFactory.getScenario(stageID))

    local map = StageFactory.getMap(stageID).create()
    map:addTo(THSTG.SceneManager.get(SceneType.MAIN).backgroundLayer)
end

function M:initPlayer()
    local roleType = ModuleCache.Stage:getRoleType()
    self._ePlayer = EntityManager.createPlayer(roleType)
    Dispatcher.dispatchEvent(EventType.STAGE_ADD_ENTITY,self._ePlayer)

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