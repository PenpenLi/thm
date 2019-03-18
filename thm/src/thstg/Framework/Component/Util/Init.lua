module("UTIL", package.seeall)

ControlMapper = require "thstg.Framework.Component.Util.ControlMapper"
TickClock = require "thstg.Framework.Component.Util.TickClock"
TaskScheduler = require "thstg.Framework.Component.Util.TaskScheduler"
StateMachine = require "thstg.Framework.Component.Util.StateMachine"
ObjectPool = require "thstg.Framework.Component.Util.ObjectPool"
FuncHookHandler = require "thstg.Framework.Component.Util.FuncHookHandler"


-----


function newControlMapper(params)
    params = params or {}
    local controlMapper = ControlMapper.new()
    for k,v in pairs(params) do
        controlMapper:registerKey(k,v)
    end
    return controlMapper
end


function newFuncHookHandler(cfg)
    local instance = FuncHookHandler.new()
    return instance
end


function newObjectPool(cfg)
    local instance = ObjectPool.new()
    return instance
end


function newStateMachine(cfg)
    local stateMachine = StateMachine.new()
    if type(cfg) == "table" then
        stateMachine:setupState(cfg)
    end
    return stateMachine
end

--
function newTaskScheduler(params)
    return TaskScheduler.new()
end

function newScheduleTask(time,callback)
    return {
        time = time,
        callback = callback,
    }
end

function newTickClock(params)
    return TickClock.new()
end