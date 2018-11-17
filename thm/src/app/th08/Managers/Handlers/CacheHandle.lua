module("CacheHandler", package.seeall)

local _caches = {}

--
local function register(moduleType, classPath)
	local Class = require(classPath)
	_caches[moduleType] = Class.new()
end


function init()
    --模块注册

end

function getCache(moduleType)
	return _caches[moduleType]
end

function clear()
	for k, v in pairs(_caches) do
		v:hide()
		v:dispose()
	end
	_caches = {}
end
