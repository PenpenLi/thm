local M = class("SchedulerComponent",THSTG.ECS.Component)

function M:_onInit()
    self._cTaskScheduler = UTIL.newTaskScheduler()  --任务管理器
end
------
function M:setTasks(task)
    self._cTaskScheduler:setTasks(task)
end

function M:getTasks(task)
    return self._cTaskScheduler:getTasks()
end
------
function M:_onUpdate(delay,entity)
    self._cTaskScheduler:poll()
end


return M