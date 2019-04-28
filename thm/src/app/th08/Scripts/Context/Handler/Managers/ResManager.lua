module("ResManager", package.seeall)
local Resources = require "Scripts.Configs.Handwork.H_Resources"

local function getNameKey(...)
    local keys = {...}
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. (v or "") .. "#"
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
			-- if __DEBUG_RESOURCES__ then
				error(string.format("ResManager.getRes ERROR: can't found: %s",pathStr))
			-- end
			break
		else
			-- if __DEBUG_RESOURCES__ then
				pathStr = pathStr .. "." ..  params[i]
			-- end
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
		path = t[resName]
	end

	if not path then
		-- path = ResManager.getEmptyImg()
		-- if __DEBUG_RESOURCES__ then
			error(string.format("ResManager.getRes ERROR: can't found: %s.%s", tostring(resType), tostring(resName)))
		-- end
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
		path =  t[resName]
	end

	if not path then
		error(string.format("ResManager.getResSub error: can't found: %s.%s.%s", tostring(resType), tostring(subType), tostring(resName)))
	end

	return path
end
------------------------------------------------------------------------
--其他资源路径获取
