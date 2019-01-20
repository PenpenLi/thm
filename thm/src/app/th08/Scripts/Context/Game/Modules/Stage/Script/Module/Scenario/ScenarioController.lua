local M = class("ScenarioController",THSTG.ECS.Script)

function M:_onInit()
    self._cTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器
end

function M:setTask(tasks)
    self._cTaskScheduler:setTasks(tasks)
end
---
function M:_onUpdate()
    self._cTaskScheduler:poll()
end

return M