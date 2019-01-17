module("UTIL", package.seeall)
local Socket = require "socket"

TickClock = class("TickClock")

local function getHighPrecisionTime()
	return Socket.gettime() * 1000
end

function TickClock:ctor()
    self._varBegin = 0        --开始时间
    self._varEnd = 0          --结束时间
    self._varFixStart = 0     --修正开始的时间
    self._varFixTime = 0      --记录暂停所花时间

    self._varTimeScale = 1.0 --时间缩放尺度
end

function TickClock:getElpased()
    local time = 0
    local span = 0
    if (self._varBegin >= self._varEnd) then
        time = getHighPrecisionTime()
    else
        time = self._varEnd
    end
    span = time - self._varBegin - self._varFixStart
    return span * self._varTimeScale
end

function TickClock:start()
    self._varBegin = getHighPrecisionTime()
end
function TickClock:pause()
    self._varFixStart = getHighPrecisionTime()
end
function TickClock:resume()
    local endTime = getHighPrecisionTime()
    self._varFixStart = self._varFixStart + (endTime - self._varFixStart)
end
function TickClock:stop()
    self._varEnd = getHighPrecisionTime()
end
function TickClock:reset()
    self._varEnd  = getHighPrecisionTime()
    self._varBegin = self._varEnd
    self._varFixStart = 0
end

function TickClock:getTimeScale()
    return self._varTimeScale
end
function TickClock:setTimeScale(fTimeScale)
    self._varTimeScale = fTimeScale
end

----
function newTickClock(params)
    return TickClock:create()
end