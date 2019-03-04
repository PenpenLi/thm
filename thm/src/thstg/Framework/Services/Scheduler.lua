module(..., package.seeall)

local scheduler = cc.Director:getInstance():getScheduler()
local stack = {}

-------------------------------------------------------
--构建定时器
--@param    #function   listener    每次触发回调的函数
--@param    #number     interval    单次触发的时间间隔(s)
--@param    #uint       repeatCount 重复次数(默认为0，0表示无限循环)
--@param    #boolean    isPaused    创建时是否处于停止状态，默认为false
--@param    #boolean    cleanup     切换帐号是否需要清除，默认为true
--@return   #uint   定时器id
function schedule(listener, interval, repeatCount, isPaused, cleanup)
	if type(isPaused) ~= "boolean" then isPaused = false end
	if type(cleanup) ~= "boolean" then cleanup = true end

	repeatCount = repeatCount or 0

	local schedulerId = -1
	local scheduledTimes = 0
	local function onSchedule(...)
		scheduledTimes = scheduledTimes + 1
		if repeatCount > 0 and scheduledTimes >= repeatCount then
			unschedule(schedulerId)
		end

		if type(listener) == "function" then
			listener(...)
		end
	end
	schedulerId = scheduler:scheduleScriptFunc(onSchedule, interval, isPaused)

	stack[schedulerId] = cleanup

	return schedulerId
end

-------------------------------------------------------
--停止定时器
--@param    #uint   handle  定时器id
function unschedule(handle)
	scheduler:unscheduleScriptEntry(handle)
	stack[handle] = nil
end

-------------------------------------------------------
--停止所有定时器(部分被标记为不清除的除外)
function unscheduleAll()
	local oldStack = stack
	stack = {}
	for k, v in pairs(oldStack) do
		if v then
			scheduler:unscheduleScriptEntry(k)
		else
			stack[k] = v
		end
	end
end

-------------------------------------------------------
--停止所有定时器
function clear()
	for k, v in pairs(stack) do
		scheduler:unscheduleScriptEntry(k)
	end
	stack = {}
end

----------------------------------------------
--延时指定时间后执行一次
--@param    #uint       time        多久后执行，传0时表示下一帧(s)
--@param    #function   listener    完成时回调函数
function scheduleOnce(time, listener)
	return schedule(listener, time, 1)
end

----------------------------------------------
--下一帧执行一次
--@param    #function   listener    回调函数
function scheduleNextFrame(listener)
	return schedule(listener, 0, 1)
end

----------------------------------------------
--每帧执行一次
--@param    #function   listener    回调函数
function scheduleEachFrame(listener)
	return schedule(listener, 0)
end

--用于测试
function size()
	return table.nums(stack)
end
