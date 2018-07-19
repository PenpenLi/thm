local M = class("Controller")

function M:ctor()
	self._view = false
	self._proxy = false

	self:_onInit()
end

function M:show(...)
	if not self._view then
		local Class = require(self:_initViewClass())
		assert(Class, "[Controller] to show the view you must set the View Class!")
		self._view = Class.new()
	end

	if not self._view:isShow() then
		self._view:show(...)
		self:_onShow(...)
	end
end

function M:hide()
	if self:isShow() then
		self._view:hide()

		self:_onHide()
	end
end

function M:isShow()
	return self._view and self._view:isShow()
end

function M:getView()
	return self._view
end

function M:getProxy()
	if not self._proxy then
		local instance = self:_initProxyInstance()
		assert(instance, "[Controller] to get the proxy you must set the Proxy Class!")
		self._proxy = instance
	end

	return self._proxy
end

--回收，切换帐号时用
function M:dispose()
	if self._view then
		self._view:dispose()
		self._view = false
	end
end

--定义View类文件路径[string]，待子类重写
function M:_initViewClass()
	return ""
end

--定义Proxy类实例引用[class]，待子类重写
function M:_initProxyInstance()
	return nil
end

--初始化时调用，待子类重写
function M:_onInit()

end

--显示View时调用，待子类重写
function M:_onShow()

end

--隐藏View时调用，待子类重写
function M:_onHide()

end

return M
