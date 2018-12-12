local M = class("Module")

function M:ctor()
    --显示时被添加到的父级对象
	self.__parent__ = false
	--真实的cc显示对象
    self.__realView__ = false

	--子模块
	self.__children__ = false
    
	self:_onInit()
end

--显示
function M:show(...)
	if not self:isShow() then
		self.__realView__ = self:_onView(...)
		
		assert(self:isViewExist(), "[View] the _onView function must return a CCNode object!")
		self.__realView__:onNodeEvent("cleanup", handler(self, self._onViewDestroy))

		assert(self.__parent__, "[View] Wanna show this, you must run setLayer with a CCNode object for this view!")
		self.__parent__:addChild(self.__realView__)

		self:_onShow()
	end
end

--隐藏
function M:hide()
	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false

		self:_onHide()
	end
end

--是否已显示
function M:isShow()
	if self:isViewExist() and self.__realView__:isRunning() then
		return true
	end
	return false
end

--设置父级对象
function M:getViewParent() return self.__parent__ end
function M:setViewParent(value)
	assert(tolua.cast(value, "cc.Node"), "[View] the setViewParent function param value must be a CCNode object!")
	self.__parent__ = value
end

--获取cc显示对象，可能为空
function M:getRealView(...)
	return self.__realView__
end


function M:dispose()
	if self.__children__ then
		for _,v in paris(self.__children__) do
			v:dispose()
		end
	end

	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false
	end
end

--判断realView是否真实存在
function M:isViewExist()
	if self.__realView__ and not tolua.isnull(self.__realView__) then
		return true
	end
	return false
end

-----
--子模块
function M:addChild(module,moduleName)
	if not moduleName then
		moduleName = module.class.__cname
	end
	self.__children__ = self.__children__ or {}
	self.__children__[moduleName] = module
end


----protected functions---------------------
-----------由子类重写------------

--待子类重写，需要return一个cc显示对象
function M:_onView(...)
	error("[View] Wanna show me the _onView function must be overrided!")
	return false
end

--realView执行析构时的回调
function M:_onViewDestroy()

end

function M:_onInit()

end
--
function M:_onShow()

end
function M:_onHide()

end

return M 

