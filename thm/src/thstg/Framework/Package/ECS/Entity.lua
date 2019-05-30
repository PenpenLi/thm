local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Entity",cc.Node)
M.EEntityFlag = {
	AddComponent = 1,
	RemoveComponent = 2,
}

function M.find(id) return ECSManager.findEntityById(id) end
function M.findEntitiesByTag(tag) return ECSManager.findEntitiesByTag(tag) end
function M.findByTag(tag) return ECSManager.findEntityWithTag(tag) end
function M.findEntitiesByName(name) return ECSManager.findEntitiesByName(name) end
function M.findByName(name) return ECSManager.findEntityWithName(name) end
function M.getAll() return ECSManager.getAllEntities() end

-----
function M._purge()

end
-----
function M:ctor()
    self.__id__ = UIDUtil.getEntityUID()
	self.__components__ = {}
	self.__flags__ = nil
	self.__isActive__ = true
	self.__isUpdating__ = false

	
	self.__compsUpdateQueue__ = {}--组件更新队列
	self.__lateEventsHandle__ = false--延后事件队列
	----
	--CCNode的回调
	--从节点进入
	--addEntity与removeEntity本该放到构造和析构里的,当时析构调用除了问题
	--由于析构有问题,因此_cleanup函数目前不能用
	ECSManager.initEntity(self)

	local function onEnter()
		function onUpdate(dTime)
			self:update(dTime)
		end
		ECSManager.addEntity(self)
		self:scheduleUpdateWithPriorityLua(onUpdate,-1)	--system的优先级要比实体更新高
		self:_enter()
	end

	--从节点移除
	local function onExit()
		self:_exit()
		self:unscheduleUpdate()
		ECSManager.removeEntity(self)
	end

	--析构
	local function onCleanup()
		--XXX:若父节点count>1,而子节点若父节点count<=1,会被干掉
		if (self:getReferenceCount() <= 1) then
			ECSManager.cleanupEntity(self)
			self:_cleanup()
		end
	end
	
    self:onNodeEvent("enter", onEnter)
	self:onNodeEvent("exit", onExit)
	self:onNodeEvent("cleanup", onCleanup)

end
--
--[[component模块]]
--组件的添加,移除应该设置在帧后
local function _addComponent(self,component,params)
	assert(not tolua.iskindof(component, "ECS.Component"), "[Entity] the addChild function param value must be a THSTG ECS.Component object!!")

	if not self.__isUpdating__ then
		-- 有些组件可以被多次添加,有些不行
		local componentPath = component:getClassPath()
		assert(componentPath, "[Entity] The component must have a unique name!")
		assert(not self.__components__[componentPath], "[Entity] component already added. It can't be added again!")
		
		if component:_added(self,params) ~= false then
			self.__components__[componentPath] = component
			local priority = component:getPriority()
			if priority > #self.__compsUpdateQueue__ then priority = #self.__compsUpdateQueue__ end
			if priority < 1 then priority = 1 end
			table.insert(self.__compsUpdateQueue__, component:getPriority(), component)
			ECSManager.addEntityComponent(component)
			return component
		end
	else
		self:_doEventLate(_addComponent,{self,component,params})
	end
end

local function _remveComponent(self,params,...)
	if not self.__isUpdating__ then
		local componentPath = ECSUtil.trans2Path(...)
		local component = self.__components__[componentPath]
		if component then
			if component:_removed(self) ~= false then
				ECSManager.removeEntityComponent(component)
				self.__components__[componentPath] = nil
				for i,v in ipairs(self.__compsUpdateQueue__) do if v == component then table.remove(self.__compsUpdateQueue__, i) break end end
				if params then
					params.comp = component
				end
			end
		end
	else
		self:_doEventLate(_remveComponent,{self,params,...})
	end
end

local function _remveComponents(self,...)
	if not self.__isUpdating__ then
		local name = ECSUtil.trans2Path(...)
		for k,v in pairs(self.__components__) do
			local classMap = v:getClassMap()
			if ECSUtil.find2ClassWithChildByClassMap(classMap,...) then
				_remveComponent(self,false,...)
			end
		end
	else
		self:_doEventLate(_remveComponents,{self,...})
	end
end

function M:addComponent(component,params)
	local comp = _addComponent(self,component,params)
	local classPath = comp:getClassPath()
	self[classPath] = comp
	return comp
end

--移除组件
function M:removeComponent(...)
	local params = {}
	_remveComponent(self,params,...)
	local classPath= params.comp:getClassPath()
	self[classPath] = nil
end

--移除组件列表
function M:removeComponents(...)
	_remveComponents(self,...)
end

function M:replaceComponent(oldComponentNamesTb,newComponent,params)
	if type(oldComponentNamesTb) == "string" then oldComponentNamesTb = {oldComponentNamesTb} end
	self:removeComponents(unpack(oldComponentNamesTb))
	if newComponent then
		return self:addComponent(self,newComponent,params)
	end
end

--
function M:getAllComponents()
	local ret = {}
	for _,v in pairs(self.__components__) do
		table.insert(ret, v)
	end
	return ret
end

--获取组件列表
function M:getComponents(...)
	local ret = {}
	for k,v in pairs(self.__components__) do
		local classMap = v:getClassMap()
		if ECSUtil.find2ClassWithChildByClassMap(classMap, ...) then
			table.insert(ret, v)
		end
	end
	
	return ret
end

--获取组件
function M:getComponent(...)
	local name = ECSUtil.trans2Path(...)
	local comp = self.__components__[name]
	return comp or self:getComponents(...)[1]
end

function M:getComponentsWithName(type,name)
	local list = {}
	local comp = {}

	if name and type(name) == "string" then
		comps = self:getComponents(type)
	else
		name = type
		comps = self.__components__
	end
	for k,v in pairs(comps) do
		if v:getName() then
			if v:getName() == name then
				table.insert( list, v)
			end
		end
	end
	return list
end

function M:getComponentWithName(...)
	return self:getComponentsWithName(...)[1]
end

function M:isHaveComponent(...)
    return self:getComponent(...) and true or false
end

function M:removeAllComponents()
	if not self.__isUpdating__ then
		self:_visitComps(function(comp)
			comp:_removed(self)
			ECSManager.removeEntityComponent(comp)
		end)

		self.__components__ = {}
		self.__compsUpdateQueue__ = {}
	end
end

--[[Script模块]]
function M:addScript(scprit,params)
	return _addComponent(self,scprit,params)
end

function M:removeScript(...)
	_remveComponents(self,...)
end

function M:getScript(...)
	return self:getComponent(...)
end

function M:replaceScript(a1,a2)
	local class = a1
	local comp = a2
	if a2 == nil then
		comp = a1
		params = a2
		local classList = comp:getClassList()
		class = clone(classList)
		table.remove(class,#class)
	else
		if type(class) == "string" then class = {class} end
	end
	self:removeScript(unpack(class))
	if comp then
		self:addScript(comp)
	end
end
---
function M:update(dTime)
	if not self:isActive() then return end
	--先control,然后才是Script
	self.__isUpdating__ = true

	self:_visitComps(function(comp)
		if comp:isEnabled() then
			comp:_onUpdate(dTime,self)
		end
	end)
	
	self:_onUpdate(dTime)

	self:_visitComps(function(comp)
		if comp:isEnabled() then
			comp:_onLateUpdate(dTime,self)
		end
	end)
	
	self:_onLateUpdate(dTime)

	self.__isUpdating__ = false
	self:_handleLateEvents()
end

----
function M:clear()
	self:removeAllComponents()
end

function M:destroy()
	ECSManager.destroyEntity(self)
	self:_onDestroy()
end

function M:clone(entity)
	return self:_onClone(entity or self)
end

function M:getID()
    return self.__id__
end

function M:setActive(isActive)
	self.__isActive__ = isActive
	self:_active(isActive)
end

function M:isActive()
	return self.__isActive__ 
end

function M:setupFlag(flag,state)
	self.__flags__ = self.__flags__ or {}
	self.__flags__[flag] = state
end

function M:haveFlag(flag)
	return (self.__flags__ and self.__flags__[flag]) and true or false
end

function M:clearFlags()
	self.__flags__ = {}
end

--[CCNode扩展]
function M:findChild(nodePath)
	local nameArray = string.split(nodePath,"/")
	local node = nil
	for i,v in ipairs(nameArray) do
		node = self:getChildByName(v)
		if not node then break end
	end
	return node
end

---
--[[
    以下函数不建议重载,违反了设计模式的思想
]]
function M:_onInit(...)

end

--进入场景回调
function M:_onEnter()
	
end

function M:_onActive(val)

end

function M:_onReset()
	
end

function M:_onDestroy()
	
end

--退出场景回调
function M:_onExit()
	
end

function M:_onCleanup()

end

function M:_onClone(entity)
	return clone(entity)
end

--每帧回调
function M:_onUpdate(dTime)

end

--逻辑更新完成
function M:_onLateUpdate(dTime)
    
end

function M:_visitComps(func)
	if type(func) == "function" then
		for index = #self.__compsUpdateQueue__,1,-1 do
			local comp = self.__compsUpdateQueue__[index]
			func(comp,index)
		end
	end
end

function M:_enter()
	self:_onEnter()
	for _,v in pairs(self.__components__) do
		v:_onEnter()
	end
end

function M:_exit()
	for _,v in pairs(self.__components__) do
		v:_onExit()
	end
	self:_onExit()

end

function M:_cleanup()
	self:clear()
	self:_onCleanup()
end

function M:_active(isActive)
	self:setVisible(isActive)
	self:_onActive()
	for k,v in pairs(self.__components__) do
		v:_onActive(isActive)
	end
end

function M:_doEventLate(func,params)
	self.__lateEventsHandle__ = self.__lateEventsHandle__ or {}
	table.insert(self.__lateEventsHandle__,{
		func = func,
		params = params,
	})
end

function M:_handleLateEvents()
	if self.__lateEventsHandle__ then
		for i,v in iparis(self.__lateEventsHandle__) do
			v.func(unpack(v.params))
		end
		self.__lateEventsHandle__ = false
	end
end

function M:_adjustComponentPriority(component)
	if not self.__isUpdating__ then
		--从队列中移除在插入
		for i = #self.__compsUpdateQueue__,1,-1 do 
			local pComp = self.__compsUpdateQueue__[i]
			if pComp == component then 
				table.remove(self.__compsUpdateQueue__, i) 
				local priority = component:getPriority()
				if priority > #self.__compsUpdateQueue__ then priority = #self.__compsUpdateQueue__ end
				if priority < 1 then priority = 1 end
				table.insert(self.__compsUpdateQueue__, priority, component)
				break 
			end 
		end
	else
		self:_doEventLate(self._adjustComponentPriority, {self,component})
	end
end
-------

return M