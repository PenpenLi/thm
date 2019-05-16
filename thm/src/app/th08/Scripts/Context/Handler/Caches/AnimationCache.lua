module("AnimationCache", package.seeall)
local CacheUtil = require("Scripts.Context.Handler.Caches.CacheUtil")

function add(tags,animation)
    if animation then
        local nameKey = CacheUtil.getNameKey(tags)
        display.setAnimationCache(nameKey,animation)
    end
end

function get(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    return display.getAnimationCache(nameKey)
end

function remove(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    display.removeAnimationCache(nameKey)
end

function clear()

end