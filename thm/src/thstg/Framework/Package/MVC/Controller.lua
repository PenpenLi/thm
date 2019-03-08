local M = class("Controller")


function M:ctor()
	self.__module__ = false

	self:_onInit()
end

---
function M:getModule()
	return self.__module__
end

function M:getView()
	return self:getModule():getView()
end
---
function M:open(...)
	self:_onOpen(...)
end

function M:close(...)
	self:_onClose(...)
end

----
function M:_onInit()

end

function M:_onOpen(...)
	
end

function M:_onClose(...)
	
end

return M
