
local M = class("StageGameController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)
    
    self._ePlayer = StageDefine.Reimu.new()
end

function M:updateStage()
    --FIXME:根据关卡改变
    local stageID = Cache.stageCache.getStageId()
    local schedulerComp = self:getComponent("SchedulerComponent")
    schedulerComp:setTasks(StageConfig.getScenario(stageID))

    local map = StageConfig.getMap(1).create()
    map:addTo(THSTG.SceneManager.get(SceneType.STAGE).backgroundLayer)
end

function M:_onStart()
    M.super._onStart(self)



    self:updateStage()
end

function M:_onUpdate()
   
end



return M