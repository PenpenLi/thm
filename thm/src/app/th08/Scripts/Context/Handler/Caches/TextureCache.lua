module("TextureCache", package.seeall)
local CacheUtil = require("Scripts.Context.Handler.Caches.CacheUtil")
local _cache = {}
function add(tags,texture)
    if texture then
        local nameKey = CacheUtil.getNameKey(tags)
        if not _cache[nameKey] then
            _cache[nameKey] = texture
            texture:retain()
        end
    end
end

function get(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    return _cache[nameKey]
end

function remove(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    local texture = _cache[nameKey]
    if texture then
        _cache[nameKey] = nil
        texture:release()
    end
end

function clear()
    for _,v in pairs(_cache) do
        v:release()
    end
    _cache = {}
end