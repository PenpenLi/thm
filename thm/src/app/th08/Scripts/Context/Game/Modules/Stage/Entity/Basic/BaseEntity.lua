module(..., package.seeall)

local M = class("BaseEntity",cc.Node)
local _entityId = 1000
function M:ctor()
	--拥有唯一UID
	_entityId = _entityId + 1
	self._id = _entityId

	self:_onInit()

	local function onUpdate(dTime)
		self:_onUpdate(dTime)
	end
	local function onEnter()
		self:_onEnterScene()
	end
	local function onExit()
		self:_onExitScene()
        self:unscheduleUpdate()
	end
	local function onCleanup()
		self:_onDestroy()
	end

	self:scheduleUpdateWithPriorityLua(onUpdate,0)
    self:onNodeEvent("enter", onEnter)
	self:onNodeEvent("exit", onExit)
	self:onNodeEvent("cleanup", onCleanup)
end

function M:getId()
	return self._id
end

------------------------------------------------------------------
--初始化
function M:_onInit()

end

--进入场景回调
function M:_onEnterScene()
	if self._entityData then
		
	end
end

--退出场景回调
function M:_onExitScene()
	if self._entityData then
		
	end
end

--销毁回调
function M:_onDestroy()
	if self._entityData then
		
		self._entityData = false
	end
end

--每帧回调
function M:_onUpdate(dTime)

end

------------------------------------------------------------------

return M