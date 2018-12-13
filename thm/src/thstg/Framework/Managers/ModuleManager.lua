module("ModuleManager", package.seeall)

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

local function __get(moduleType)
    local module = _modules[moduleType]
    assert(module, string.format( "[ModuleManager] Can not find the Module[\"%s\"]!",moduleType))
    return module
end

-------------
--[[
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
	playSound -- 是否播放打开音效
}
]]

function open(moduleType,params)
	params = params or {}
	local module = __get(moduleType)
	if not module then 
		return
	end
	if module:isOpend() and params.key == nil then
		return
	end


	local function residentShow()
		_residentModules[moduleType] = true
		module:open(params)
	end

	local function noResidentShow()
		if params.closeOthers then
			closeAll(1)
		elseif params.key ~= nil then
			module:close()
		end
		
		_openedModules[moduleType] = true
		module:open(params)
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

function close(moduleType)
	local module = __get(moduleType)
	if not module or not module:isOpen() then
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
