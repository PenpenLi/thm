module("SpriteFrameCache", package.seeall)
local CacheUtil = require("Scripts.Context.Handler.Caches.CacheUtil")
local SpriteFrameCache = cc.SpriteFrameCache:getInstance()
local _Md5Cache = {}
function add(tags,frame)
    if frame then
        local nameKey = CacheUtil.getNameKey(tags)
        SpriteFrameCache:addSpriteFrame(frame,nameKey)
        _Md5Cache[nameKey] = true
    end
end

function get(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    if not _Md5Cache[nameKey] then return nil end
    
    return SpriteFrameCache:getSpriteFrame(nameKey)
end

function remove(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    SpriteFrameCache:removeSpriteFrameByName(nameKey)
    _Md5Cache[nameKey] = nil
end

function clear()
    SpriteFrameCache:removeSpriteFrames()
    _Md5Cache= {}
end