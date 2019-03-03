local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Entity",cc.Node)

function M.find(id) return ECSManager.findEntityById(id) end
function M.findEntitiesByTag(tag) return ECSManager.findEntitiesByTag(tag) end
function M.findByTag(tag) return ECSManager.findEntityWithTag(tag) end
function M.findEntitiesByName(name) return ECSManager.findEntitiesByName(name) end
function M.findByName(name) return ECSManager.findEntityWithName(name) end
function M.getAll() return ECSManager.getAllEntities() end
function M.getAllEx(entity) return ECSManager.getAllEntities(entity) end

-- local ECompType = {Control = 1,Script = 2}	--组件类型
-----
function M._purge()

end
-----
function M:ctor()
    self.__id__ = UIDUtil.getEntityUID()
	self.__components__ = {}
	self.__flags__ = nil
	self.__isActive__ = true
	----
	--CCNode的回调
	--从节点进入
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
		self:_cleanup()
	end
	
    self:onNodeEvent("enter", onEnter)
	self:onNodeEvent("exit", onExit)
	self:onNodeEvent("cleanup", onCleanup)
    ----
	self:addComponent(ECS.TransformComponent.new())
end
--
--[[component模块]]
local function _addComponent(self,component,params)
	assert(not tolua.iskindof(component, "ECS.Component"), "[Entity] the addChild function param value must be a THSTG ECS.Component object!!")

	-- 有些组件可以被多次添加,有些不行
	local componentName = component:getClass()
	assert(componentName, "[Entity] The component must have a unique name!")
	assert(not self.__components__[componentName], "[Entity] component already added. It can't be added again!")
	self.__components__[componentName] = component
		
	component:_added(self,params)
end

local function _remveComponent(self,...)
	local name = ECSUtil.trans2Name(...)
	local component = self.__components__[name]
	if component then
		component:_removed(self)
		self.__components__[name] = nil
	end
end

function M:addComponent(component,params)
	_addComponent(self,component,params)
end

--移除组件
function M:removeComponent(...)
	_remveComponent(self,...)
end

--移除组件列表
function M:removeComponents(...)
	local name = ECSUtil.trans2Name(...)
	for k,v in pairs(self.__components__) do
		local className,classArgs = v:getClass()
		if ECSUtil.find2ClassWithChild(classArgs,...) then
			self:removeComponent(unpack(classArgs))
		end
	end
end

--
function M:getAllComponents()
	local ret = {}
	for _,v in pairs(self.__components__) do
		table.insert( ret, v )
	end
	return ret
end

--获取组件列表
function M:getComponents(...)
	local ret = {}
	for k,v in pairs(self.__components__) do
		local _,classArgs = v:getClass()
		if ECSUtil.find2ClassWithChild(classArgs,...) then
			table.insert( ret, v )
		end
	end
	
	return ret
end

--获取组件
function M:getComponent(...)
	local name = ECSUtil.trans2Name(...)
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
	for name,_ in pairs(self.__components__) do
		self:removeComponent(name)
	end
end

--[[脚本模块]]
function M:addScript(scprit,params)
	_addComponent(self,scprit,params)
end

function M:removeScript(...)
	_remveComponent(self,...)
end

function M:getScript(...)
	return self:getComponent(...)
end

--[[系统模块]]
function M:getSystem(name)
	return ECSManager.getSystem(name)
end
---
function M:update(dTime)
	if not self:isActive() then return end
	--先control,然后才是Script
	
	for k,v in pairs(self.__components__) do
		if v:isEnabled() then
			v:_onUpdate(dTime,self)
		end
	end
	
	self:_onUpdate(dTime)

	for k,v in pairs(self.__components__) do
		if v:isEnabled() then
			v:_onLateUpdate(dTime,self)
		end
	end
	
	self:_onLateUpdate(dTime)

end

function M:clear()
	self:removeAllComponents()
end

function M:destroy()
	ECSManager.destroyEntity(self)
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


--发送事件
function M:dispatch(e,params)
	ECSManager.dispatchEvent(ECSManager.EEventCacheType.Entity,e,params)
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
--

--消息
function M:_onEvent(event,params)

end
---
function M:_event(event,params)
	self:_onEvent(event,params)
	for _,v in pairs(self.__components__) do
		v:_onEvent(event,params)
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
	self:_onActive()
	for k,v in pairs(self.__components__) do
		v:_onActive(isActive)
	end
end
-------

return M