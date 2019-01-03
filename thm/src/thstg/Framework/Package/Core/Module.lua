local M = class("Module")

function M:ctor()
	--子模块
	self.__children__ = false
	self.__parent__ = false

	--真实的cc显示对象
    self.__realView__ = false
	--模块是否被打开
	self.__isOpend__ = false
	--模块名
	self.__moduleName__ = self.__cname 

	self:_onInit()
end
------

--显示
function M:show(...)
	if not self:isShow() then
		self.__realView__ = self:_onView(...)
		
		assert(self:isViewExist(), "[Module] the _onView function must return a CCNode object!")
		self.__realView__:onNodeEvent("cleanup", handler(self, self._onViewDestroy))

		assert(self.__realView__:getParent(), "[Module] Wanna show this, you must run addTo with a CCNode object for this view!")
	end
end

function M:tryShow(...)
	if not self:isShow() then
		self.__realView__ = self:_onView(...)
		if self:isViewExist() then
			assert(self.__realView__:getParent(), "[Module] Wanna show this, you must run addTo with a CCNode object for this view!")
		end
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
	if self:isViewExist() and self.__realView__:isRunning() then
		return true
	end
	return false
end

--获取cc显示对象，可能为空
function M:getView(...)
	return self.__realView__
end


--判断realView是否真实存在
function M:isViewExist()
	if self.__realView__ and not tolua.isnull(self.__realView__) then
		return true
	end
	return false
end

-----

--遍历所有子类
function M:visit(self,func)
	if self.__children__ then
		for i = #self.__children__,1,-1 do
			func(self.__children__[i],i)
		end
	end
end

function M:dispose()
	self:visit(function(v)
		v:dispose()
	end)
	
	if self:isShow() then
		self.__realView__:removeFromParent()
		self.__realView__ = false
	end
	
	self:_onDispose()
end

function M:open(...)
	--模块打开,可能伴随窗口打开,但不一定有窗口
	self:tryShow(...)
	self:_onOpen(...)
	self.__isOpend__ = true
	--打开所有子模块
	local args = {...}
	self:visit(self,function(v,i)
		v:open(unpack(args))
	end)

end

function M:close(...)
	--关闭所有子模块
	local args = {...}
	self:visit(self,function(v,i)
		v:close(unpack(args))
	end)
	self:hide()
	self:_onClose(...)
	self.__isOpend__ = false
end

function M:isOpend()
	if self:isViewExist() then
		return self:isShow()
	else 
		return self.__isOpend__
	end
end

function M:getName() return self.__moduleName__ end
function M:setName(name)
	self.__moduleName__ = name
end

--
function M:addTo(parent)
	parent:addChild(self)
end
function M:addChild(module)
	assert(not tolua.cast(module, "Module"), "[Module] the addChild function param value must be a THSTG Module object!!")
	assert(not module.__parent__, "[Module] child already added. It can't be added again!")
	self.__children__ = self.__children__ or {}
	table.insert(self.__children__, module)
	module.__parent__ = self
end

function M:removeFromParent()
	if self.__parent__ then
		self.__parent__:visit(function (v,i)
			if v == self then
				table.remove( self.__parent__.__children__, v )
			end
		end)
	end
end

function M:getParent()
	return self.__parent__
end

function M:getChildren()
	return self.__children__
end

function M:getChildrenByName(name)
	local list = {}
	self:visit(function (v,i)
		if v:getName() == name then
			table.insert( list, v )
		end
	end)

	return list
end


----protected functions---------------------
-----------由子类重写------------

--待子类重写，需要return一个cc显示对象
function M:_onView(...)
	
	return false
end

--realView执行析构时的回调
function M:_onViewDestroy()

end

function M:_onInit()

end

function M:_onOpen(...)
	
end

function M:_onClose(...)
	
end

function M_onDispose()

end

return M 

