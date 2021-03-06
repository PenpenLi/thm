
--[[
    任务表例子
    {
        time = 10,  --单位时间s(与实际时间无关)
        tag = nil,
        callback = function(sender)
        end,
    }
]]

local M = class("TaskScheduler")
function M:ctor()
    self._pollClock = UTIL.newTickClock()

    self._varTaskTable = {}  --任务表
    self._varTaskQueue = {}  --执行表
    self._varInterval = 100

    self._varCurTime = 0
    self._varIsPause = false
    self._varUserData = nil

    self._varTaskUID = 10000

end
local function getFixTime(self,time)
   return math.ceil(1000/self._varInterval*time)
end
local function pushTaskTable(self,taskInfo)
    local id = taskInfo.__id
    self._varTaskTable[id] = taskInfo
end

local function pushTaskQueue(self,taskInfo)
    local time = taskInfo.time
    local fixTime = getFixTime(self,time)
    self._varTaskQueue[fixTime] = self._varTaskQueue[fixTime] or {}
    table.insert(self._varTaskQueue[fixTime], taskInfo)
end

function M:push(time,callback,tag)
    local taskInfo = nil
    if type(time) == "table" then
        if type(time.callback) == "function" and type(time.time) == "number" and time.time >=0 then
            taskInfo = time
        else
            return -1
        end
        
    elseif  type(callback) == "function" and type(time) == "number" and time.time >=0 then
        local function makeTask(time,callback,tag)
            local info = {
                time = time,
                callback = callback,
                tag = tag,
            }
            return info
        end

        taskInfo = makeTask(time,callback,tag)
    else
        return -1
    end


    self._varTaskUID = self._varTaskUID + 1
    rawset(taskInfo,"__id",self._varTaskUID)
    pushTaskTable(self,taskInfo)
    pushTaskQueue(self,taskInfo)

    return self._varTaskUID
  
end

function M:tickTime()
   return self._varCurTime
end

function M:time()
    return self._varCurTime/(1000/self._varInterval)
end

--FIXME:如果跳过时间,因为之前的任务已经被移除,因此可能造成不在执行,往前跳的话又会因为没移除而出错
-- function M:jumpTo(time)
--     self._varCurTime = getFixTime(self,time)
-- end

-- function M:jumpBy(offsetTime)
--     self._varCurTime = self._varCurTime + getFixTime(self,offsetTime)
-- end


function M:pause()
    self._varIsPause = true
end

function M:isPause()
    return self._varIsPause
end

function M:resume()
    self._varIsPause = false
end

function M:reset(startTime)
    startTime = startTime or 0
    self._varCurTime = startTime
    self._varTaskQueue = {}
    for k,v in pairs(self._varTaskTable) do 
        pushTaskQueue(self,v)
    end

end

function M:removeByTag(tag,isRelease)
    if tag == nil then return end
    for k,v in pairs(self._varTaskTable) do
        if v.tag == tag then
            local fixTime = getFixTime(self,v.time)
            local timeTb = self._varTaskQueue[fixTime]
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

function M:removeById(id,isRelease)
    if type(id) ~= "number" then return end
    local info = self._varTaskTable[id]
    if info then

        local time = info.time
        local fixTime = getFixTime(self,time)
        local timeTb = self._varTaskQueue[fixTime]
        for i,v in ipairs(timeTb) do
            if v.__id == info.__id then
                table.remove(self._varTaskQueue[fixTime], i )
            end
        end

        if isRelease then self._varTaskTable[id] = nil end
    end
   
end

function M:removeByTime(time,isRelease)
    if type(time) ~= "number" then return end
    for k,v in pairs(self._varTaskTable) do
        if v.time == time then
            local fixTime = getFixTime(self,v.time)
            local timeTb = self._varTaskQueue[fixTime]
            if timeTb then
                self._varTaskQueue[fixTime]= nil
            end
            if isRelease then self._varTaskTable[k] = nil end
        end
    end

end

function M:clear()
    self._pollClock:reset()
    self._varCurTime = 0
    self._varTaskTable = {}  --任务表
    self._varTaskQueue = {}  --执行表
end

--
function M:setTasks(tasks)
    tasks = tasks or {}
    self:clear()
    for _,v in ipairs(tasks) do
        self:push(v)
    end
end

function M:getTasks()
    return self._varTaskQueue
end

function M:getTasksByTag(tag)
    if tag == nil then return end

    local tasks = {}
    for _,v in pairs(self._varTaskQueue) do
        if v.tag == tag then
            table.insert( tasks, v )
        end
    end

    return tasks
end

function M:getInterval()
    return self._varInterval
end

function M:setInterval(interval)
    self._varInterval = interval
end

function M:getUserData()
    return self._varUserData
end

function M:setUserData(data)
    self._varUserData = data
end

--轮询函数
function M:poll()
    if self._pollClock:getElpased() >= self._varInterval then
        if not self:isPause() then
            local funsTb = self._varTaskQueue[self._varCurTime]
            if funsTb then
                local function exec(funsTb)
                    while true do
                        if not next(funsTb) then break end
                        local i = next(funsTb)
                    
                        local data = self:getUserData()
                        local ret = funsTb[i].callback(self,funsTb[i],data)
                        table.remove(funsTb, i) --循环状态不能对数组操作
  
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

return M