local MVCUtil = require "thstg.Framework.Package.MVC.MVCUtil"
local M = class("Module")

function M:ctor()
	--模块名
	self.__moduleName__ = self.__cname 
	self.__id__ = UIDUtil.getModuleUID()

	--子模块
	self.__children__ = false
	self.__parent__ = false

	--View实例
	self.__view__ = false
	--Ctrl实例
	self.__ctrl__ = false

	--模块是否被打开
	self.__isOpend__ = false


	self:_onInit()
end
------
function M:getView()
	return self.__view__
end

function M:getCtrl()
	return self.__ctrl__
end


function M:isViewExist()
	return self.__view__ and true or false
end

function M:isCtrlExist()
	return self.__ctrl__ and true or false
end

------

--遍历所有子类
function M:visit(self,func)
	if self.__children__ then
		for i = #self.__children__,1,-1 do
			func(self.__children__[i],i)
		end
	end
end

function M:_tryShow(...)
	if self:getCtrl() then
		self:getCtrl():open(...)
	end

	if self:getView() then
		self:getView():tryShow(...)
	end

end

function M:_tryHide(...)
	if self:getCtrl() then
		self:getCtrl():close(...)
	end
	
	if self:getView() then
		self:getView():tryHide(...)
	end
end

function M:open(...)
	--模块打开,可能伴随窗口打开,但不一定有窗口
	self:_tryShow(...)

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

	self:_tryHide()

	self:_onClose(...)
	self.__isOpend__ = false
end

function M:isOpend()
	if self:isViewExist() then
		return self:getView():isShow()
	else 
		return self.__isOpend__
	end
end

function M:getName() return self.__moduleName__ end

------
function M:addTo(parent)
	parent:addChild(self)
end

function M:addChild(module)
	assert(not tolua.iskindof(module, "Module"), "[Module] the addChild function param value must be a THSTG Module object!!")
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
--定义View类文件路径[string]，待子类重写
function M:_initViewClass()
	return ""
end

--定义Ctrl类文件路径[string]，待子类重写
function M:_initCtrlClass()
	return ""
end


function M:_onInit()

end

function M:_onRegistered()

end


function M:_onOpen(...)
	
end

function M:_onClose(...)
	
end

----------------------------
function M:_registered(...)
	local ctrlClass = self:_initCtrlClass() ~= "" and require(self:_initCtrlClass()) or false
	local viewClass = self:_initViewClass() ~= "" and require(self:_initViewClass()) or false
	
	if ctrlClass then 
		self.__ctrl__ = ctrlClass.new() 
		self.__ctrl__.__module__ = self	--在这里设置,以免被覆盖
	end

	if viewClass then 
		self.__view__ = viewClass.new() 
		self.__view__.__module__ = self	--在这里设置,以免被覆盖
	end

	self:_onRegistered(...)
end


return M 

