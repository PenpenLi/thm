local M = class("THSTG.MVC.View")

function M:ctor()
	--显示时被添加到的父级对象
	self.__parent__ = false
	--真实的cc显示对象
	self.__realView__ = false
end

----public functions---------------------

--显示
function M:show(...)
	if not self:isShow() then
		assert(self.__parent__, "[View] Wanna show this, you must run setLayer with a CCNode object for this view!")

		self.__realView__ = self:_initRealView(...)
		assert(self:isRealViewExist(), "[View] the _initRealView function must return a CCNode object!")
		self.__realView__:onNodeEvent("cleanup", handler(self, self._onRealViewDestroy))

		self.__parent__:addChild(self.__realView__)
	end
end

--隐藏
function M:hide()
	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false
	end
end

--是否已显示
function M:isShow()
	if self:isRealViewExist() and self.__realView__:isRunning() then
		return true
	end
	return false
end

--设置父级对象
function M:getLayer() return self.__parent__ end
function M:setLayer(value)
	assert(tolua.cast(value, "cc.Node"), "[View] the setLayer function param value must be a CCNode object!")
	self.__parent__ = value
end

--获取cc显示对象，可能为空
function M:getRealView(...)
	return self.__realView__
end

function M:update(reason, data, ...)

end

function M:dispose()
	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false
	end
end

--判断realView是否真实存在
function M:isRealViewExist()
	if self.__realView__ and not tolua.isnull(self.__realView__) then
		return true
	end
	return false
end

----protected functions---------------------

--待子类重写，需要return一个cc显示对象
function M:_initRealView(...)
	error("[View] Wanna show me the _initRealView function must be overrided!")
	return false
end

--realView执行析构时的回调
function M:_onRealViewDestroy()

end

return M