module("EntityDataCache", package.seeall)
local _cache = {}

function add(code, data)
    _cache[code] = data
end

function get(code)
    return _cache[code]
end

function clear()
    _cache = {}
end