module("ResManager", package.seeall)
local Resources = require "Configs.Handwork.Resources"

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
-- 多层资源获取
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


function getResTable(resType, subType)
	local res = Resources[resType]
	if subType and res then
		res = res[subType]
	end

	return res or {}
end

--------------------------
--[[
获取组件资源
@param	uiType		[string]组件类型	(对应UIType中的项)
@param	resName		[string]资源名
@return 资源路径
--]]
function getUIRes(uiType, resName)
	return getResSub(ResType.UI, uiType, resName)
end

-- --获取空图片的资源路径
-- function getEmptyImg()
-- 	TextureManager:getInstance():getDefaultLoadingImage() -- 重置加载图
-- 	return getRes(ResType.PUBLIC, "empty")
-- end