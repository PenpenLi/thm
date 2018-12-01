module("UIDUtil", package.seeall)

local _eventId = 100000000000

local _moduleId = 0

local _mapId = 10000

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

--模块的唯一id
function getModuleUID()
	_moduleId = _moduleId + 1
	return _moduleId
end

--地图唯一id
function getMapUID()
	_mapId = _mapId + 1
	return _mapId
end

