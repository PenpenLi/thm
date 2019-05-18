module("TextureCache", package.seeall)
local CacheUtil = require("Scripts.Context.Handler.Caches.CacheUtil")
local TextureCache = cc.TextureCache:getInstance()

function add(tags,texture)
    if texture then
        local nameKey = CacheUtil.getNameKey(tags)
        TextureCache:addImage(texture,nameKey)
    end
end

function get(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    return TextureCache:getTextureForKey(nameKey)
end

function remove(tags)
    local nameKey = CacheUtil.getNameKey(tags)
    TextureCache:removeTextureForKey(nameKey)
end

function clear()
    TextureCache:removeAllTextures()
end