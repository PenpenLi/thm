local EventDispatcher = require "thstg.Framework.Component.Event.EventDispatcher"

module("DispatcherManager", package.seeall)

--存放所有EventDispatcher实例
local _dispatchers = {}
local _dispatcherUID = 0

--[[
将创建一个新EventDispatcher实例，并返回该实例对应的唯一id
@return 
	1	[int]	EventDispatcher实例对应的唯一id，对应事件发布器
	2	[table]	EventDispatcher实例
]]
function getNewId()
	_dispatcherUID = _dispatcherUID + 1
	local d = EventDispatcher.new()
	_dispatchers[_dispatcherUID] = d
	return _dispatcherUID,d
end

function getNew()
	local _,dispatcher = getNewId()
	return dispatcher
end

--[[
获取一个EventDispatcher
@param	id	[number]	对应EventDispatcher实例的id，若对应id无实例将报错
@return 当参数id有值时，返回对应EventDispatcher实例
]]
function getDispatcher(id)
	if not _dispatchers[id] then
		assert(false, "The Dispatcher id:" .. id .. " is nil, you can create a new instance without params!")
		return nil
	end

	return _dispatchers[id]
end

--清除对应id的dispatcher
function clearDispatcher(id)
	_dispatchers[id] = nil
end

--清除所有
function clear()
	for k, v in pairs(_dispatchers) do
		v:clear()
	end
	_dispatchers = {}
	_dispatcherUID = 0
end

--------------------

--[[
添加事件侦听
@dispatcherId	[number]对应Dispatcher的id
@name			[string]事件名
@listener		[function]侦听器
@listenerCaller	[Object]侦听函数调用者
@priority		[int]权重，值越大越先被执行
--]]
function addEventListener(dispatcherId, name, listener, listenerCaller, priority)
	local dispatcher = getDispatcher(dispatcherId)
	if dispatcher then
		dispatcher:addEventListener(name, listener, listenerCaller, priority)
	end
end

--[[
移除事件侦听
@dispatcherId	[number]对应Dispatcher的id
@name			[string]事件名
@listener		[function]侦听器
--]]
function removeEventListener(dispatcherId, name, listener)
	local dispatcher = getDispatcher(dispatcherId)
	if dispatcher then
		dispatcher:removeEventListener(name, listener)
	end
end

--[[
发布事件
@dispatcherId	[number]对应Dispatcher的id
@name			[string]事件名
@...			其它参数
--]]
function dispatchEvent(dispatcherId, name, ...)
	local dispatcher = getDispatcher(dispatcherId)
	if dispatcher then
		dispatcher:dispatchEvent(name, ...)
	end
end

--[[
是否存在该事件侦听
@dispatcherId	[number]对应Dispatcher的id
@name			[string]事件名
--]]
function hasEventListener(dispatcherId, name)
	local dispatcher = getDispatcher(dispatcherId)
	if dispatcher then
		return dispatcher:hasEventListener(name)
	end
	return false
end

-------------------
--实例个数，用于测试
function getSize()
	return table.nums(_dispatchers)
end

