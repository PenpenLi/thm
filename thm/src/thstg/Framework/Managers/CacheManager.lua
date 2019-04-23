module("CacheManager", package.seeall)
local _allCache = {}
local _cacheDict = {}

--动态添加
function addCache(name, classPath)
	assert(name ~= nil and name ~= "", "name is empty")
	assert(classPath ~= nil and classPath ~= "", "classPath is empty")

	if _allCache[name] then
		error(string.format("cache %s already existed.", name))
	else
		_allCache[name] = require(classPath).new()
		_cacheDict[classPath] = name
	end
end

function removeCache(name)
	local cache = getCache(name)
	if cache then
		clearCache(name)
		for k,v in pairs(_cacheDict) do
			if v == name then
				_cacheDict[k] = nil
				break
			end
		end
		_allCache[name] = nil
	end
end

function getCache(name)
	return _allCache[name]
end

function setCache(name,classPath)
	removeCache(name)
	addCache(name,classPath)
end

function reloadCache(classPath, newClass)
	local key = _cacheDict[classPath]
	local cls = _allCache[key]
	local newCache = newClass.new()
	for k, v in pairs(newCache) do
		if cls[k] ~= nil then
			newCache[k] = cls[k]
		end
	end
	_allCache[key] = newCache
end

function clearCache(name)
	local _cache = _allCache[name]
	if _cache then
		_cache:clear()
	end
end

function init()

end

function clearAll()
	for _,v in pairs(_cacheDict) do
		v:clear()
	end
	_cacheDict = {}
end