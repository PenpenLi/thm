module("UIDUtil", package.seeall)

local _uid = 0
local _eventId = 10000000
--ECS
local _componentId =    1000
local _entityId =       2000
local _systemId =       3000

--MVC
local _moduleId = 0

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

-----
--模块的唯一id
function getModuleUID()
	_moduleId = _moduleId + 1
	return _moduleId
end

function getEntityUID()
    _entityId = _entityId + 1
    return _entityId
end

function getSystemUID()
    _systemId = _systemId + 1
    return _systemId
end

function getComponentUID()
    _componentId = _componentId + 1
    return _componentId
end