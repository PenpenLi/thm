module("ResManager", package.seeall)
local Resources = require "Scripts.Configs.Handwork.Resources"


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

------------
-- --获取空图片的资源路径
-- function getEmptyImg()
-- 	TextureManager:getInstance():getDefaultLoadingImage() -- 重置加载图
-- 	return getRes(ResType.PUBLIC, "empty")
-- end

--------------------------
--[[
获取组件资源
@param	uiType		[string]组件类型	(对应UIType中的项)
@param	resName		[string]资源名
@return 资源路径
--]]
function getModuleRes(moduleType, ...)
	return getResMul(ResType.MODULE, moduleType, ...)
end


--------------------------
--[[
获取组件资源
@param	uiType		[string]组件类型	(对应UIType中的项)
@param	resName		[string]资源名
@return 资源路径
--]]
function getUIRes(uiType, ...)
	return getResMul(ResType.UI, uiType, ...)
end

--------------------------
--[[
获取组件资源
@param	uiType		[string]组件类型	(对应UIType中的项)
@param	resName		[string]资源名
@return 资源路径
--]]
function getUIPublicRes(uiType, ...)
	return getResMul(ResType.UIPUBLIC, uiType, ...)
end
--------------------------
--[[
获取纹理资源
@param	texType		[string]纹理类型	(对应texType中的项)
@param	resName		[string]资源名
@return 资源表
--]]
function getTexDict(texType)
	return getResMul(ResType.TEXTURE, texType)
end

function getTexRes(texType, ...)
	return getResMul(ResType.TEXTURE, texType ,...)
end

-------
--[[
获取动画资源
@param	texType		[string]纹理类型	(对应texType中的项)
@param	resName		[string]资源名
@return 资源表
--]]
function getAnimationDict(texType, ...)
	return getResMul(ResType.ANIMATION, texType, ... )
end

function getAnimationRes(texType, ...)
	return getResMul(ResType.ANIMATION, texType, ...)
end

--[[
获取粒子资源
@param	ParticleType		[string]纹理类型	(对应ParticleType中的项)
@param	resName		[string]资源名
@return 资源表
--]]

function getParticleRes(particleType, ...)
	return getResMul(ResType.SFX, SFXType.PARTICLE, particleType, ...)
end