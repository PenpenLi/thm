local M = class("Queue")

function M:ctor()
    self._varObjQueue = {}
    self._varQueueFront = 0
    self._varQueuRear = 0
end


function M:push(data)
	self._varQueuRear = self._varQueuRear + 1
    self._varObjQueue[self._varQueuRear] = data
    return true
end

function M:pop()
	if self:isEmpty() then
		return 
	end
	self._varQueueFront = self._varQueueFront + 1
	self._varObjQueue[self._varQueueFront] = nil
	
end

function M:front(default)
    if self:isEmpty() then
        return default
    end
	return self._varObjQueue[self._varQueueFront + 1]
end

function M:length()
	return self._varQueuRear - self._varQueueFront
end

function M:clear()
	while( not self:isEmpty() ) do self:pop() end
	self._varQueueFront = 0
    self._varQueuRear = 0
    self._varObjQueue = {}
end


function M:isEmpty()
	if (self:length() <= 0) then
		return true
	else
		return false
	end
end

return M