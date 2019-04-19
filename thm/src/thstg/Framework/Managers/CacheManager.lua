module("CacheManager", package.seeall)
local _allCache = {}
local _cacheDict = {}
setmetatable(Cache, {
	__index = function(_, k)
		return _allCache[k]
	end
})

--动态添加
function addCache(name, classPath)
	assert(name ~= nil and name ~= "", "name is empty")
	assert(classPath ~= nil and classPath ~= "", "classPath is empty")

	if _allCache[name] then
		error(string.format("cache %s already existed.", name))
	else
		_allCache[name] = require(classPath):new()
		_cacheDict[classPath] = name
	end
end

function reloadCache(classPath, newClass)
	-- print(5, "reloadCache", classPath, newClass)
	-- dump(5, newClass, classPath .. " === reloadCache")
	local key = _cacheDict[classPath]
	local cls = _allCache[key]
	local newCache = newClass:new()
	for k, v in pairs(newCache) do
		-- dump(5, v, k)
		if cls[k] ~= nil then
			newCache[k] = cls[k]
		end
	end
	_allCache[key] = newCache
end

function clear()
	_cacheDict = {}
end