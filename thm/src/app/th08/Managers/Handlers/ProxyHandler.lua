module("ProxyHandler", package.seeall)

local _proxies = {}

--
local function register(moduleType, classPath)
	local Class = require(classPath)
	_proxies[moduleType] = Class.new()
end

function init()
	--模块注册
	register(ModuleType.TEST, "Scripts.Modules.Test.TestProxy")
	
end


function getProxy(moduleType)
	return _proxies[moduleType]
end

function clear()
	_proxies = {}
end
