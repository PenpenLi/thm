module("MVCManager", package.seeall)

local _dispatcher = EVENT.DispatcherManager.getNew()
--[[ 常驻模块
主界面ui
]]

--注册的模块
local _modulesClass = {}
local _modules = {}

-- 正在打开的常驻模块
local _residentModules = {}
-- 正在打开的普通模块
local _openedModules = {}

-----------------------------------
function getDispatcher()
	return _dispatcher
end
function registerModule(moduleType, classPath)
	assert(moduleType, string.format("[MVCManager] ModuleType is not finded"))
	assert(classPath, string.format("[MVCManager] ModuleClassPath is not finded"))
	table.insert(_modulesClass, {moduleType = moduleType,classPath = classPath})
end

function getModule(moduleType)
	return _modules[moduleType]
end

-------------
--[[
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
}
]]
function openModule(moduleType,params)
	params = params or {}
	local module = getModule(moduleType)
	if not module then 
		return
	end
	if module:isOpend() and params.key == nil then
		return
	end


	local function residentShow()
		_residentModules[moduleType] = true
		module:open(params)
		getDispatcher():dispatchEvent(TYPES.MVCEVENT.MVC_MODULE_OPENED, moduleType)
	end

	local function noResidentShow()
		if params.closeOthers then
			closeAllModules(1)
		elseif params.key ~= nil then
			module:close()
		end
		
		_openedModules[moduleType] = true
		module:open(params)
		getDispatcher():dispatchEvent(TYPES.MVCEVENT.MVC_MODULE_CLOSED, moduleType)
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

function closeModule(moduleType)
	local module = getModule(moduleType)
	if not module or not module:isOpend() then
		return
	end

	if _openedModules[moduleType] then

		module:close()
		_openedModules[moduleType] = nil
		
	end

	if _residentModules[moduleType] then
		module:close()
		_residentModules[moduleType] = nil
		
	end
end

--[[ 关闭所有模块
allType
nil 都关闭
1 - 只关闭普通模块
2 - 只关闭常驻模块
]]
function closeAllModules(allType)
	if allType == nil or allType == 1 then
		for k, v in pairs(_openedModules) do
			closeModule(k)
		end
	end

	if allType == nil or allType == 2 then
		for k, v in pairs(_residentModules) do
			closeModule(k)
		end
	end
end

-- 检测某模块是否处于打开状态
function isModuleOpened(moduleType)
	if _openedModules[moduleType] then
		return true
	end

	if _residentModules[moduleType] then
		return true
	end
	return false
end

-- 是否有一个以上的普通模块被打开了
function isOpenedAnyModule()
	for k, v in pairs(_openedModules) do
		if v then
			return true
		end
	end
	return false
end


------
function init()
	local function openModule(_,e,moduleType,params)
		if moduleType then
			openModule(moduleType,params)
		end
	end

	local function closeModule(_,e,moduleType,params)
		if moduleType then
			closeModule(pmoduleType,params)
		end
	end
	getDispatcher():addEventListener(TYPES.MVCEVENT.MVC_OPEN_MODULE, openModule)
    getDispatcher():addEventListener(TYPES.MVCEVENT.MVC_CLOSE_MODULE, closeModule)

	---实例化所有模块
	for _,v in pairs(_modulesClass) do
		local Class = require(v.classPath)
		local module = Class.new()
		assert(module, string.format("[MVCManager] Module creation failed!(%s)",v.classPath))
		module:_registered()
		_modules[v.moduleType] = module
	end
end

function clear()
	getDispatcher():clear()
	closeAllModules()
	for k, v in pairs(_modules) do
		v:close()
	end
	_modules = {}
end
