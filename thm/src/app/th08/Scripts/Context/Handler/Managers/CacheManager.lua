module("CacheManager", package.seeall)

local _caches = {}

function register(path)
    local filesName = string.split(path,".")
    local file = filesName[#filesName]
    _caches[file] = {classPath = path}
end

function get(name)
    return _caches[name].classPath
end

function clear()
    for _,v in pairs(_caches) do
        v.classPath.clear()
    end
end