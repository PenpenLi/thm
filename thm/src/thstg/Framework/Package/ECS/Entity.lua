local M = class("Entity",cc.Node)
local EFlagType = {Destroy = 1}

function M:ctor()
    self.__id__ = ECS.ECSUtil.getEntityId()
	self.__components__ = false
	self.__flags__ = false
    ----

	local function onEnter()
		local function onUpdate(dTime)
			self:update(dTime)
		end
		self:scheduleUpdateWithPriorityLua(onUpdate,0)
		self:_onEnter()
	end
	local function onExit()
		self:_onExit()
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

	--有些组件可以被多次添加,有些不行
	local componentName = component:getName()
	assert(componentName, "[Entity] The component must have a unique name!")
	assert(not self.__components__[componentName], "[Entity] component already added. It can't be added again!")
	self.__components__[componentName] = component

	component:_added(self,params)
end
local function _remveComponent(self,name,params)
	if self.__components__ then
		local component = self.__components__[name]
		if component then
			component:_removed(self,params)
			self.__components__[name] = nil
		end
	end
end

function M:addComponent(component,params)
	_addComponent(self,component,params)
end
--移除组件
function M:removeComponent(name,params)
	_remveComponent(self,name,params)
end
--获取组件
function M:getComponent(...)
	if self.__components__ then
		local name = ECS.ECSUtil.trans2Name(...)
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

-- function M:removeScript(scprit,params)
-- 	_remveComponent(self,scprit,params)
-- end

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
--

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
				if v:isEnabled() then
					v:_onDestroy()
				end
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