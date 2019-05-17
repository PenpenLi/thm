module("SpriteFrameCache", package.seeall)
local CacheUtil = require("Scripts.Context.Handler.Caches.CacheUtil")
local SpriteFrameCache = cc.SpriteFrameCache:getInstance()

function add(tags,frame)
    if frame then
        local nameKey = CacheUtil.getNameKey(tags)
        SpriteFrameCache:addSpriteFrame(frame,nameKey)
    end
end

function get(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    return SpriteFrameCache:getSpriteFrame(nameKey)
end

function remove(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    SpriteFrameCache:removeSpriteFrameByName(nameKey)
end

function clear()
    SpriteFrameCache:removeSpriteFrames()
end