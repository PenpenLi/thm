module("TimeUtil", package.seeall)

-- 获取高精度时间
local function getHighPrecisionTime()
	local socket = require "socket"
	return socket.gettime() * 1000
end

function time()
	return getHighPrecisionTime() / 1000
end

function msTime()
	return getHighPrecisionTime()
end

-- 获取与服务器时间差值：秒
function getOffsetTime(seconds)
	return math.abs(Cache.serverTimeCache.getServerTime() - seconds)
end

-- 格式化时间：xx秒，xx分钟，xx小时，xx天
function getFormatTimeByType(seconds, type)
	local value = getOffsetTime(seconds)
	if type == "s" then
		return value
	elseif type == "m" then
		return math.floor(value / 60)
	elseif type == "h" then
		return math.floor(value / 3600)
	elseif type == "d" then
		return math.floor(value / 86400)
	end
end

function getPreDayTime(seconds)
	local date = Cdl.createDate(seconds)
	return seconds - (date.hour * 3600 + date.min * 60 + date.sec)
end

-- 格式化差值时间
function getFormatOffsetTime(seconds)
	local value = getOffsetTime(seconds)
	if value < 60 then
		return Language.getString(106201)
	elseif value > 60 and value < 3600 then
		return Language.getString(106202, math.floor(value / 60))
	elseif value > 3600 and value < 86400 then
		return Language.getString(106203, math.floor(value / 3600))
	else
		return Language.getString(106204, math.floor(value / 86400))
	end
end

function getDate(seconds)
	local date = Cdl.createDate(seconds)
	local dateStr = string.format("%d-%d-%d %d:%d:%d", date.year, date.month, date.day, date.hour, date.min, date.sec)
	print(225, "date:", dateStr)
	return dateStr,date
end

-- xx:xx:xx的格式化
function formatTime(seconds)
	local hour = math.floor(seconds / 3600)
	hour = hour < 10 and ("0"..hour) or hour
	local min = math.floor(seconds%3600 / 60)
	min = min < 10 and ("0"..min)or min
	local sec = math.floor(seconds%60)
	sec = sec < 10 and ("0"..sec)or sec

	return hour..":"..min..":"..sec
end

-- 倒计时
local timeHandleT = {}
function newCountDown(seconds, callFun, isOffset)
	local count = seconds
	if isOffset then
		count = getOffsetTime(seconds)
	end
	local id = THSTG.Scheduler.schedule(function()
		callFun(formatTime(count))
		count = count - 1
	end, 1)
	timeHandleT[id] = true
	return id
end
-- 倒计时析构
function clearCountDown(id)
	if timeHandleT[id] then
		THSTG.Scheduler.unschedule(id)
		timeHandleT[id] = nil
	end
end
