local M = {}

local _, _dispatcher = DispatcherManager.getNewId()

function M.addEventListener(name, listener, listenerCaller, priority)
	_dispatcher:addEventListener(name, listener, listenerCaller, priority)
end

function M.removeEventListener(name, listener)
	_dispatcher:removeEventListener(name, listener)
end

function M.dispatchEvent(name, ...)
	_dispatcher:dispatchEvent(name, ...)
end

function M.hasEventListener(name)
	_dispatcher:hasEventListener(name)
end

function M.clear()
	_dispatcher:clear()
end

M.__newindex = function(t, k, v)
	error("[Dispatcher] Can't create new property or function!")
end

return M
