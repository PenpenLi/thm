module("ModuleManager", package.seeall)

--[[ 常驻模块
主界面ui
]]

--注册的模块
local _modulesClass = {}
local _modules = {}

-- 正在显示的常驻模块
local _residentModules = {}
-- 正在显示的普通模块
local _openedModules = {}

-----------------------------------

function register(moduleType, classPath)
	table.insert(_modulesClass, {moduleType = moduleType,classPath = classPath} )
end

function init()
	for _,v in pairs(_modulesClass) do
		local Class = require(v.classPath)
		_modules[v.moduleType] = Class.new()
	end
end

function get(moduleType)
	return _modules[moduleType]
end
-------------
--[[
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
	playSound -- 是否播放打开音效
}
]]

function show(moduleType,params)
	params = params or {}
	local module = get(moduleType)
	if not module then 
		return
	end
	if module:isShow() and params.key == nil then
		return
	end


	local function residentShow()
		_residentModules[moduleType] = true
		module:show(params)
		
	end

	local function noResidentShow()
		if params.closeOthers then
			hideAll(1)
		elseif params.key ~= nil then
			module:close()
		end
		
		_openedModules[moduleType] = true
		module:show(params)
		
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

function hide(moduleType)
	local module = get(moduleType)
	if not module or not module:isShow() then
		return
	end

	if _openedModules[moduleType] then

		module:hide()
		_openedModules[moduleType] = nil
		
		
	end

	if _residentModules[moduleType] then
		module:hide()
		_residentModules[moduleType] = nil
		
	end
end

--[[ 关闭所有模块
allType
nil 都关闭
1 - 只关闭普通模块
2 - 只关闭常驻模块
]]
function hideAll(allType)
	if allType == nil or allType == 1 then
		for k, v in pairs(_openedModules) do
			hide(k)
		end
	end

	if allType == nil or allType == 2 then
		for k, v in pairs(_residentModules) do
			hide(k)
		end
	end
end

-- 检测某模块是否处于打开状态
function isShow(moduleType)
	if _openedModules[moduleType] then
		return true
	end

	if _residentModules[moduleType] then
		return true
	end
	return false
end

-- 是否有一个以上的普通模块被打开了
function isShowAny()
	for k, v in pairs(_openedModules) do
		if v then
			return true
		end
	end
	return false
end


------
function clear()
	closeAll()
	for k, v in pairs(_modules) do
		v:close()
		v:dispose()
	end
	_modules = {}
end


-------------------
