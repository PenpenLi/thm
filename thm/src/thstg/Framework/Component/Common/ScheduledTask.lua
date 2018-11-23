module("COMMON", package.seeall)

--[[
    任务表例子
    {
        time = 10,  --单位时间s(与实际时间无关)
        tag = nil,
        callback = function(sender)
        end,
    }
]]

local ScheduledTask = class("ScheduledTask")
function ScheduledTask:ctor()
    self._pollClock = COMMON.newTickClock()

    self._varTaskTable = {}  --任务表
    self._varTaskQueue = {}  --执行表
    self._varInterval = 100

    self._varCurTime = 0
    self._varIsPause = false

    self._varTaskUID = 10000

end
local function pushTaskTable(self,taskInfo)
    local id = taskInfo.__id
    self._varTaskTable[id] = taskInfo
end

local function pushTaskQueue(self,taskInfo)
    local time = taskInfo.time
    self._varTaskQueue[time] = self._varTaskQueue[time] or {}
    table.insert(self._varTaskQueue[time], taskInfo)
end

function ScheduledTask:push(time,callback,tag)
    local function makeTask(time,callback,tag,id)
        local fixTime = math.ceil(1000/self._varInterval*time)
        local info = {
            time = fixTime,
            callback = callback,
            tag = tag,
            __id = id
        }
        return info

    end
    if type(callback) == "function" then
        self._varTaskUID = self._varTaskUID + 1
        local taskInfo = makeTask(time,callback,tag,self._varTaskUID)

        pushTaskTable(self,taskInfo)
        pushTaskQueue(self,taskInfo)

        return self._varTaskUID
    end

    return -1
end

function ScheduledTask:tickTime()
   return self._varCurTime
end

function ScheduledTask:time()
    return self._varCurTime/(1000/self._varInterval)
 end

function ScheduledTask:pause()
    self._varIsPause = true
end

function ScheduledTask:isPause()
    return self._varIsPause
end

function ScheduledTask:resume()
    self._varIsPause = false
end

function ScheduledTask:reset(startTime)
    startTime = startTime or 0
    self._varCurTime = startTime
    self._varTaskQueue = {}
    for k,v in pairs(self._varTaskTable) do 
        pushTaskQueue(self,v)
    end

end

function ScheduledTask:removeByTag(tag,isRelease)
    if tag == nil then return end
    for k,v in pairs(self._varTaskTable) do
        if v.tag == tag then
            local timeTb = self._varTaskQueue[v.time]
            if timeTb then
                for i,vv in ipairs(timeTb) do
                    if vv.tag == tag then
                        table.remove(self._varTaskQueue,i)
                    end
                end
            end
            if isRelease then self._varTaskTable[k] = nil end
        end
    end
  
end

function ScheduledTask:removeById(id,isRelease)
    if type(id) ~= "number" then return end
    local info = self._varTaskTable[id]
    if info then

        local time = info.time
        local timeTb = self._varTaskQueue[time]
        for i,v in ipairs(timeTb) do
            if v.__id == info.__id then
                table.remove(self._varTaskQueue[time], i )
            end
        end

        if isRelease then self._varTaskTable[id] = nil end
    end
   
end

function ScheduledTask:removeByTime(time,isRelease)
    if type(time) ~= "number" then return end
    for k,v in pairs(self._varTaskTable) do
        if v.time == time then
            local timeTb = self._varTaskQueue[v.time]
            if timeTb then
                self._varTaskQueue[v.time]= nil
            end
            if isRelease then self._varTaskTable[k] = nil end
        end
    end

end

function ScheduledTask:clear()
    self._pollClock:reset()
    self._varCurTime = 0
    self._varTaskTable = {}  --任务表
    self._varTaskQueue = {}  --执行表
end

--
function ScheduledTask:setTasks(tasks)
    tasks = tasks or {}
    self:clear()
    for _,v in ipairs(tasks) do
        self:push(v.time,v.callback,v.tag)
    end
end

function ScheduledTask:getTasks()
    return self._varTaskQueue
end

function ScheduledTask:getInterval()
    return self._varInterval
end

function ScheduledTask:setInterval(interval)
    self._varInterval = interval
end

--轮询函数
function ScheduledTask:poll()
    if self._pollClock:getElpased() >= self._varInterval then
        if not self:isPause() then
            local funsTb = self._varTaskQueue[self._varCurTime]
            if funsTb then
                local function exec(funsTb)
                    for i,v in ipairs(funsTb) do
                        local ret = v.callback(self)
                        table.remove(funsTb, i)
                        
                        if self:isPause() then --如果在某个回调里暂停了时间
                            if ret == true then
                                exec(funsTb)
                            end
                            return true
                        end
                    end
                    return false
                end
                if exec(funsTb) then return end
                self._varTaskQueue[self._varCurTime] = nil
            end
            self._varCurTime = self._varCurTime + 1
        end

        self._pollClock:reset()
    end
end

--
function newScheduledTask(params)
    return ScheduledTask:create()
end