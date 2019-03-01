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
	self:_onShow(...)
end

function M:close(...)
	self:_onHide(...)
end

----
function M:_onInit()

end

function M:_onShow(...)
	
end

function M:_onHide(...)
	
end

return M
