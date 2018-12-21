module("MVCManager", package.seeall)

local _ctrls = {}
-- 正在打开的常驻模块
local _residentModules = {}

-- 正在打开的普通模块
local _openedModules = {}

--注册contrller
function registerController(moduleType, classPath)
	local Class = require(classPath)
	_ctrls[moduleType] = Class.new()
end

function getController(moduleType)
	return _ctrls[moduleType]
end
-------

--[[ 打开模块
moduleType 模块名
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
}
]]
function openView(moduleType, params)
	params = params or {}
	local ctrl = getController(moduleType)
	if not ctrl then 
		return
	end
	if ctrl:isShow() and params.key == nil then
		return
	end

	local function residentShow()
		_residentModules[moduleType] = true
		ctrl:show(params)
		
	end

	local function noResidentShow()
		if params.closeOthers then
			closeAll(1)
		elseif params.key ~= nil then
			ctrl:hide()
		end
		_openedModules[moduleType] = true
		ctrl:show(params)
		
	end

	if params.closeOthers == nil then 
		params.closeOthers = true 
	end

	if params.isResident then
		residentShow()
	else
		noResidentShow()
	end	

end

--关闭指定模块
function closeView(moduleType)
	local ctrl = getController(moduleType)
	if not ctrl or not ctrl:isShow() then
		return
	end

	if _openedModules[moduleType] then

		ctrl:hide()
		_openedModules[moduleType] = nil

	end

	if _residentModules[moduleType] then
		ctrl:hide()
		_residentModules[moduleType] = nil
		
	end
end


--[[ 关闭所有模块
allType
nil 都关闭
1 - 只关闭普通模块
2 - 只关闭常驻模块
]]
function closeAllViews(allType)
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
function isOpenedView(moduleType)
	if _openedModules[moduleType] then
		return true
	end

	if _residentModules[moduleType] then
		return true
	end
	return false
end

-- 是否有一个以上的普通模块被打开了
function isOpenedAnyView()
	for k, v in pairs(_openedModules) do
		if v then
			return true
		end
	end
	return false
end

function printOpenedView()
	dump(__PRINT_TYPE__, _openedModules, "打开了这些模块 _openedModules")
	dump(__PRINT_TYPE__, _residentModules, "打开了这些模块 _residentModules")
end

function checkView( ... )
	local flag = false
	for k,v in pairs(_openedModules) do
		local ctrl = getController(k)
		local close = false
		if ctrl and ctrl:isShow() then
		else
			close = true
			flag = true
		end
		if close then
			_openedModules[k] = nil
		end 
	end
	return flag
end

--------
function init()

end
function clear()
	for k, v in pairs(_ctrls) do
		v:hide()
		v:dispose()
	end
	_ctrls = {}
end
