local M = class("View")

function M:ctor()
	--模块实例
	self.__module__ = false

	--显示时被添加到的父级对象
	self.__parent__ = false
	--真实的cc显示对象
	self.__realView__ = false

	self:_onInit()
end
---
function M:getModule()
	return self.__module__
end

function M:getCtrl()
	return self:getModule():getView()
end
----------------
--判断realView是否真实存在
function M:isRealViewExist()
	if self.__realView__ and not tolua.isnull(self.__realView__) then
		return true
	end
	return false
end

--获取realView
function M:getRealView()
	return self.__realView__
end

--显示
function M:show(...)
	if not self:isShow() then
		self.__realView__ = self:_onRealView(...)
		
		assert(self:isRealViewExist(), "[Module] the _onRealView function must return a CCNode object!")
		self.__realView__:onNodeEvent("cleanup", handler(self, self._onRealViewCleanup))

		assert(self.__realView__:getParent(), "[Module] Wanna show this, you must run addTo with a CCNode object for this view!")
	end
end

function M:tryShow(...)
	if not self:isShow() then
		self.__realView__ = self:_onRealView(...)
		if self:isRealViewExist() then
			self.__realView__:onNodeEvent("cleanup", handler(self, self._onRealViewCleanup))
			assert(self.__realView__:getParent(), "[Module] Wanna show this, you must run addTo with a CCNode object for this view!")
			return false
		end
	end
	return true
end

--隐藏
function M:hide()
	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false
	end
end

function M:tryHide(...)
	return self:hide()
end

--是否已显示
function M:isShow()
	if self:isRealViewExist() and self.__realView__:isRunning() then
		return true
	end
	return false
end

---
function M:_onInit()
	
end

--待子类重写，需要return一个cc显示对象
function M:_onRealView()
	-- error("[View] Wanna show me the _onRealView function must be overrided!")
	return false
end

--realView执行析构时的回调
function M:_onRealViewCleanup()

end

return M