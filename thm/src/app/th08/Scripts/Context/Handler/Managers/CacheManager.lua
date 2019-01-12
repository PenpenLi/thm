module("CacheManager", package.seeall)

local _caches = {}

function register(path)
    table.insert( _caches, {classPath = path})
end

function clear()
    for _,v in pairs(_caches) do
        v.classPath.clear()
    end
end