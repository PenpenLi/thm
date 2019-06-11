module("ResManager", package.seeall)
local H_Resources = require "Scripts.Configs.Handwork.H_Resources"
local F_Respreload = require "Scripts.Template.F_Respreload"

local function getNameKey(...)
    local keys = {...}
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. (v or "") .. "#"
    end
    keyName = THSTG.MD5.string(keyName)

    return keyName
end

-------
function init()
	local preload = F_Respreload["_Global"]
	preload()
end
--------------
-- 多层资源获取
-- @param	...		[string]	资源类型
-- @return	资源路径
function getRes(...)
	local path = nil
	local params = {...}
	
	for i = 1, #params do
		path = path and path[params[i]] or H_Resources[params[i]]
		if not path then
			-- if __DEBUG_RESOURCES__ then
				local pathStr = ""
				for j = 1, #params do
					pathStr = string.format("%s/%s",pathStr,params[j])
				end
				pathStr = string.sub(pathStr, 2)
				error(string.format("ResManager.getRes ERROR: can't found: %s",pathStr))
			-- end
			break
		end
	end
	return path
end

function getUIRes(UIType,...)
	return getRes(ResType.MODULE,ModuleType.UI,UIType,...)
end

function getModuleRes(moduleType,...)
	return getRes(ResType.MODULE,moduleType,...)
end
