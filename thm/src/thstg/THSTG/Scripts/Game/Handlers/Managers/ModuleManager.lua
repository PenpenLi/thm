module("ModuleManager", package.seeall)

--[[ 常驻模块
主界面ui
]]

-- 正在打开的常驻模块
local _residentModules = {}

-- 正在打开的普通模块
local _openedModules = {}


--[[
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
	playSound -- 是否播放打开音效
}
]]
function open(moduleType,params)
	params = params or {}
	local ctrl = ControllerManager.getCtrl(moduleType)
	if not ctrl then 
		return
	end
	if ctrl:isShow() and params.key == nil then
		return
	end
	THSTG.Dispatcher.dispatchEvent(EventType.PUBLIC_MODULE_OPENING, moduleType)


	local function residentShow()
		_residentModules[moduleType] = true
		ctrl:show(params)
		THSTG.Dispatcher.dispatchEvent(EventType.PUBLIC_MODULE_OPENED, moduleType)
	end

	local function noResidentShow()
		if params.closeOthers then
			closeAll(1)
		elseif params.key ~= nil then
			ctrl:hide()
		end
		
		_openedModules[moduleType] = true
		ctrl:show(params)
		THSTG.Dispatcher.dispatchEvent(EventType.PUBLIC_MODULE_OPENED, moduleType)

		if params.playSound then
			SoundManager.playSound("open")
		end
	end

	if params.closeOthers == nil then 
		params.closeOthers = true 
	end
	if params.playSound == nil then 
		params.playSound = true 
	end

	if params.isResident then
		residentShow()
	else
		noResidentShow()
	end	
end

function close(moduleType)
	local ctrl = GameController.getCtrl(moduleType)
	if not ctrl or not ctrl:isShow() then
		return
	end

	if _openedModules[moduleType] then

		ctrl:hide()
		_openedModules[moduleType] = nil
		
		THSTG.Dispatcher.dispatchEvent(EventType.PUBLIC_MODULE_CLOSED, moduleType)
	end

	if _residentModules[moduleType] then
		ctrl:hide()
		_residentModules[moduleType] = nil
		THSTG.Dispatcher.dispatchEvent(EventType.PUBLIC_MODULE_CLOSED, moduleType)
	end
end

--[[ 关闭所有模块
allType
nil 都关闭
1 - 只关闭普通模块
2 - 只关闭常驻模块
]]
function closeAll(allType)
	if allType == nil or allType == 1 then
		for k, v in pairs(_openedModules) do
			close(k)
		end
	end

	if allType == nil or allType == 2 then
		for k, v in pairs(_residentModules) do
			close(k)
		end
	end
end

-- 检测某模块是否处于打开状态
function isOpened(moduleType)
	if _openedModules[moduleType] then
		return true
	end

	if _residentModules[moduleType] then
		return true
	end
	return false
end

-- 是否有一个以上的普通模块被打开了
function isOpenedAny()
	for k, v in pairs(_openedModules) do
		if v then
			return true
		end
	end
	return false
end