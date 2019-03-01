module("UIDUtil", package.seeall)

local _eventId = 10000000

local _uid = 0

--获取全局唯一的id
function getUID()
	_uid = _uid + 1
	return _uid
end

--事件名的唯一id
function getEventUID()
	_eventId = _eventId + 1
	return _eventId
end
