local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Entity",cc.Node)

function M.find(id) return ECSManager.findEntityById(id) end
function M.findEntitysWithTag(tag) return ECSManager.findEntitysWithTag(tag) end
function M.findWithTag(tag) return ECSManager.findEntityWithTag(tag) end
function M.getAll() return ECSManager.getAllEntities() end
function M.getAllEx(entity) return ECSManager.getAllEntities(entity) end

local EFlagType = {Destroy = 1}
-----
function M:ctor()
    self.__id__ = ECSUtil.getEntityId()
	self.__components__ = false
	self.__flags__ = false
    ----

	local function onEnter()
		local function onUpdate(dTime)
			self:update(dTime)
		end
		self:scheduleUpdateWithPriorityLua(onUpdate,0)
		self:_enter()
		ECSManager.addEntity(self)
	end
	local function onExit()
		ECSManager.removeEntity(self)
		self:_exit()
        self:unscheduleUpdate()
	end
	local function onCleanup()
		self:_onCleanup()
		self:clear()
	end
	
	
    self:onNodeEvent("enter", onEnter)
	self:onNodeEvent("exit", onExit)
	self:onNodeEvent("cleanup", onCleanup)
	---

	-- self:_onInit()
end
--
--[[component模块]]
local function _addComponent(self,component,params)
	assert(not tolua.cast(component, "ECS.Component"), "[Entity] the addChild function param value must be a THSTG ECS.Component object!!")

	self.__components__ = self.__components__ or {}
	-- 有些组件可以被多次添加,有些不行
	local componentName = component:getClass()
	assert(componentName, "[Entity] The component must have a unique name!")
	assert(not self.__components__[componentName], "[Entity] component already added. It can't be added again!")
	self.__components__[componentName] = component

	component:_added(self,params)
end
local function _remveComponent(self,...)
	if self.__components__ then
		local name = ECSUtil.trans2Name(...)
		local component = self.__components__[name]
		if component then
			component:_removed(self)
			self.__components__[name] = nil
		end
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
	if self.__components__ then
		local name = ECSUtil.trans2Name(...)
		for k,v in pairs(self.__components__) do
			local className = v:getClass()
			if ECSUtil.find2Class(className,...) then
				local argName = ECSUtil.trans2Args(className)
				self:removeComponent(unpack(argName))
			end
		end
	end
end
--
function M:getAllComponents()
	local ret = {}
	if self.__components__ then
		for _,v in pairs() do
			table.insert( ret, v )
		end
	end
	return ret
end
--获取组件列表
function M:getComponents(...)
	local ret = {}
	if self.__components__ then
		local name = ECSUtil.trans2Name(...)
		for k,v in pairs(self.__components__) do
			local className = v:getClass()
			if ECSUtil.find2Class(className,...) then
				table.insert( ret, v )
			end
		end
	end
	return ret
end

--获取组件
function M:getComponent(...)
	if self.__components__ then
		local name = ECSUtil.trans2Name(...)
		return self.__components__[name]
	end
	return nil
end

function M:isHaveComponent(...)
    return self:getComponent(...) and true or false
end

function M:removeAllComponents()
	if self.__components__ then
		for name,_ in pairs(self.__components__) do
			self:removeComponent(name)
		end
	end
end

--[[脚本模块]]
function M:addScript(scprit,params)
	_addComponent(self,scprit,params)
end

function M:removeScript(scprit,params)
	_remveComponent(self,scprit,params)
end

function M:getScript(name)
	return self:getComponent(ECS.Script.__cname,name)
end

---
function M:update(dTime)
	if self.__components__ then
		for k,v in pairs(self.__components__) do
			if v:isEnabled() then
				v:_onUpdate(dTime,self)
			end
		end
	end
	self:_onUpdate(dTime)

	if self.__components__ then
		for k,v in pairs(self.__components__) do
			if v:isEnabled() then
				v:_onLateUpdate(dTime,self)
			end
		end
	end
	self:_onLateUpdate(dTime)
	self:__onUpdateFinish()
end

function M:clear()
	self:removeAllComponents()
end

function M:destroy()
	self:__setFlag(EFlagType.Destroy,true)
end

function M:getID()
    return self.__id__
end

---
--[[以下由子类重载]]
function M:_onInit(...)

end

--进入场景回调
function M:_onEnter()
	
end

--退出场景回调
function M:_onExit()
	
end

--销毁回调
function M:_onDestroy()
	
end

function M:_onCleanup()

end
--每帧回调
function M:_onUpdate(dTime)

end

--逻辑更新完成
function M:_onLateUpdate(dTime)
    
end

---
function M:_enter()
	if self.__components__ then
		for k,v in pairs(self.__components__) do
			v:_onEnter()
		end
	end
	self:_onEnter()
end
function M:_exit()
	self:clear()
	if self.__components__ then
		for k,v in pairs(self.__components__) do
			v:_onExit()
		end
	end
	self:_onExit()
end
-----
function M:__setFlag(flag,state)
	self.__flags__ = self.__flags__ or {}
	self.__flags__[flag] = true
end

function M:__isFlag(flag)
	if self.__flags__ then
		return self.__flags__[flag]
	end
	return false
end
function M:__flagHandle()
	if self:__isFlag(EFlagType.Destroy) then
		self:__setFlag(EFlagType.Destroy,nil)

		if self.__components__ then
			for k,v in pairs(self.__components__) do
				v:_onDestroy()
			end
		end
		
		self:_onDestroy()
		self:removeFromParent()

	end
end
function M:__onUpdateFinish()
	self:__flagHandle()

end

return M