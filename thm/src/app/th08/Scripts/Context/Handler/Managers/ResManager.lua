﻿module("ResManager", package.seeall)
local Resources = require "Scripts.Configs.Handwork.Resources"
local PreLoadRes = require "Scripts.Configs.Handwork.PreLoadRes"
local function getNameKey(...)
    local keys = {...}
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. v .. "#"
    end
    keyName = THSTG.MD5.string(keyName)

    return keyName
end
--------------
-- 多层资源获取
-- @param	...		[string]	资源类型
-- @return	资源路径
function getResMul(...)
	
	local path = nil
	local params = {...}
	local pathStr = ""
	for i = 1, #params do
		path = path and path[params[i]] or Resources[params[i]]
		if not path then
			if __DEBUG_RESOURCES__ then
				error(string.format("ResManager.getRes ERROR: can't found: %s",pathStr))
			end
			break
		else
			if __DEBUG_RESOURCES__ then
				pathStr = pathStr .. "." ..  params[i]
			end
		end
	end
	
	return path
end

--[[
获取资源
@param	resType		[string]资源类型	(对应ResTypes中的项)
@param	resName		[string]资源名
@return 资源路径
]]
function getRes(resType, resName)
	--ResourceManager:getInstance():getDefaultLoadingImage() -- 重置加载图

	local path = nil

	local t = Resources[resType]
	if t then
		return t[resName]
	end

	if not path then
		-- path = ResManager.getEmptyImg()
		if __DEBUG_RESOURCES__ then
			error(string.format("ResManager.getRes ERROR: can't found: %s.%s", tostring(resType), tostring(resName)))
		end
	end

	return path
end

--------------------------
-- 子层资源获取
-- @param	resType		[string]	资源类型
-- @param	subType		[string]	子级资源类型
-- @param	resName		[string]	资源名
-- @return	资源路径
function getResSub(resType, subType, resName)
	local path = nil

	local t = getRes(resType, subType)
	if t then
		return t[resName]
	end

	if not path then
		error(string.format("ResManager.getResSub error: can't found: %s.%s.%s", tostring(resType), tostring(subType), tostring(resName)))
	end

	return path
end
------------------------------------------------------------------------
--带缓存的对象创建
function createAnimation(altasName,aniName)
	local nameKey = getNameKey(altasName,aniName)
    local animation = display.getAnimationCache(nameKey)
    if not animation then
		local ret = THSTG.AnimationSystem.createAnimation(altasName,aniName)
        if not ret then return nil
        else
            display.setAnimationCache(nameKey,ret)
        end
        return ret
    end
    return animation
end

function cleanAnimationCache()
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end
------------------------------------------------------------------------
--TODO:资源预加载
local defCallback = function(...) end
function preload(name,callback)
	callback = callback or defCallback
	if name ~= nil then
		if type(PreLoadRes[name]) == "function" then
			PreLoadRes[name](callback)
		end
	end
end

function release( ... )
	
end

-----------------------------------------------------------------------
function init()
	preload("_Global",defCallback)
end
