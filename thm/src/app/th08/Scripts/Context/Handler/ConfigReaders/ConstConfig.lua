module("ConstConfig", package.seeall)

local _dict = nil

local function getDict()
	if not _dict then
		_dict = {}
		local t_const = require "Scripts.Configs.Handwork.Const"
		for k, v in ipairs(t_const) do
			_dict[v.constName] = v
		end
	end
	return _dict
end

--获取整条信息
function getConstInfoByName(constName)
	return getDict()[constName]
end

--获取两个value
function getConstValueByName(constName)
	local t = getConstInfoByName(constName)
	if t then
		return t.constValue, t.constValueEx
	end
	return nil, nil
end