local M = class("EventDispatcher")

local ipairs = ipairs
local t_insert = table.insert
local t_remove = table.remove
local t_sort = table.sort

--用于权重排序
local function sortListeners(a, b)
	if a.priority == b.priority then
		return a.index < b.index
	else
		return a.priority > b.priority
	end
end

--构造方法
function M:ctor(args)
	self.__eventMap__ = {}
end

function M:clear()
	self.__eventMap__ = {}
end

--[[
添加事件侦听
@name			[string]事件名
@listener		[function]侦听器
@listenerCaller	[Object]侦听函数调用者
@priority		[int]权重，值越大越先被执行，为0时按添加的先后顺序执行(默认为0)
--]]
function M:addEventListener(name, listener, listenerCaller, priority)
	assert(type(name) == "string" or type(name) == "number", "Invalid event name of argument 1, need a string or number!")
	assert(type(listener) == "function", "Invalid listener function!")

	priority = priority or 0
	assert(type(priority) == "number", "Invalid priority value, need a int!")

	local eventT = self.__eventMap__[name]
	if eventT == nil then
		eventT = {
			__index__ = 0,			--索引值，用于权重值相同的项能按添加顺序进行排序
			__listeners__ = {},		--用于快速判断某事件对应的侦听器是否存在
			__isLocked__ = false,	--是否被锁住，用于防止在dispatch事件的过程中，对该事件的侦听器列表进行增减操作导致的异常
			__operations__ = nil	--被锁住时添加或删除的事件列表，与__isLocked__一起使用
		}
		self.__eventMap__[name] = eventT
	end

	if eventT.__isLocked__ then
		if not eventT.__operations__ then
			eventT.__operations__ = {}
		end
		t_insert(eventT.__operations__, {type = 1, name = name, listener = listener, listenerCaller = listenerCaller, priority = priority})
		return
	end

	local isExist = false
	local needSort = false

	for k, v in ipairs(eventT) do
		if v.listener == listener and v.listenerCaller == listenerCaller then
			isExist = true

			if v.priority ~= priority then
				v.priority = priority

				needSort = true
			end

			break
		end
	end
	
	if not isExist then
		eventT.__index__ = eventT.__index__ + 1
		eventT.__listeners__[listener] = true
		t_insert(eventT, {listener = listener, listenerCaller = listenerCaller, priority = priority, index = eventT.__index__})
		needSort = true
	end

	if needSort and #eventT > 1 then
		t_sort(eventT, sortListeners)
	end
end

--[[
移除事件侦听
@name		[string]事件名
@listener	[function]侦听器
--]]
function M:removeEventListener(name, listener)
	assert(type(name) == "string" or type(name) == "number", "Invalid event name of argument 1, need a string or number!")
	assert(type(listener) == "function", "Invalid listener function!")

	local eventT = self.__eventMap__[name]
	if eventT ~= nil then
		if eventT.__isLocked__ then
			if not eventT.__operations__ then
				eventT.__operations__ = {}
			end
			t_insert(eventT.__operations__, {type = 2, name = name, listener = listener})
			return
		end

		eventT.__listeners__[listener] = nil
		for i=#eventT, 1, -1 do
			if eventT[i].listener == listener then
				t_remove(eventT, i)
			end
		end
	end
end

--判断侦听器是否存在
function M:_isListenerExist(name, listener)
	local eventT = self.__eventMap__[name]
	if eventT and eventT.__listeners__[listener] then
		return true
	end
	return false
end

--[[
发布事件
@name		[string]事件名
@...		其它参数
--]]
function M:dispatchEvent(name, ...)
	assert(type(name) == "string" or type(name) == "number", "Invalid event name of argument 1, need a string or number!")

	local eventT = self.__eventMap__[name]
	if eventT ~= nil then

		eventT.__isLocked__ = true
		for k, v in ipairs(eventT) do
			if self:_isListenerExist(name, v.listener) then
				v.listener(v.listenerCaller, name, ...)
			end
		end
		eventT.__isLocked__ = false

		if eventT.__operations__ then
			for k, v in ipairs(eventT.__operations__) do
				if v.type == 1 then -- 增加
					self:addEventListener(v.name, v.listener, v.listenerCaller, v.priority)
				elseif v.type == 2 then -- 删除
					self:removeEventListener(v.name, v.listener)
				end
			end
			eventT.__operations__ = nil
		end
	end
end

--[[
是否存在该事件侦听
@name	事件名
--]]
function M:hasEventListener(name)
	assert(type(name) == "string" or type(name) == "number", "Invalid event name of argument 1, need a string or number!")
	return self.__eventMap__[name] ~= nil
end

return M
