module("THSTG.Language", package.seeall)

local _dict = nil

local function getDict()
	if not _dict then
		_dict = require "thstg.Scripts.Game.Configs.Handwork.Description"
	end
	return _dict
end

--[[
数据格式化
]]
local function changeString(str, ...)
	if type(str) ~= "string" then return "" end
	
	if select("#", ...) > 0 then
		str = string.format(str, ...)
	end
	
	return str
end

--[[
根据id获取字符串
@param id 		对应配置文件中的id
@param ...		与对应字符串中相应的替换符号匹配
@return 

@example	
[10001] = "这是测试%d的%s"
Language.getString(10001, 1, "aaa") -- 这是测试1的aaa
]]
function getString(id, ...)
	if not id then return "" end
	
	local str = getDict()[id] or ""
	
	return changeString(str, ...)
end

--[[
根据id获取数组
]]
function getArray(id)
	if not id then return "" end
	
	local str = getDict()[id] or ""
	
	return string.split(str, ",")
end


--[[
	获取数字对应中文字符串(目前可以转换0~99999)
	@example 	getChineseNumString(10034) return  "一万零三十四"
--]]
function getChineseNumString(number)
	local zero = 100020
	local ten = 100030
	local result = ""
	if number == 0 then
		result = getString(zero)
		return result
	end
	local i = 1  			--数位记录
	local pre0 = false  	--上一位是否是0
	local temp0 = false 	--缓存字符零
	local temp1 = false 	--缓存字符一
	while(number ~= 0) do
		local n = number%10    --当前位数字
		--个位
		if i == 1 then
			if n ~= 0 then
				result = getString(zero+n)
			else
				pre0 = true
			end
		--十位
		elseif i == 2 then
			if n == 0 then
				if not pre0 then
					temp0 = getString(zero)
				end
				pre0 = true
			elseif n == 1 then 
				temp1 = getString(zero+1)
				result = string.format("%s%s",getString(ten),result)
				pre0 = false
			else
				result = string.format("%s%s%s",getString(zero+n),getString(ten),result)
				pre0 = false
			end
		--其他位
		else
			if n == 0 then
				if not pre0 then
					temp0 = getString(zero)
				end
				if temp1 then
					result = string.format("%s%s",getString(zero+1),result)
					temp1 =false
				end
				pre0 = true
			else
				if temp0 then
					result = string.format("%s%s",getString(zero),result)
					temp0 = false
				end
				if temp1 then
					result = string.format("%s%s",getString(zero+1),result)
					temp1 =false
				end
				result = string.format("%s%s%s",getString(zero+n),getString(ten+i-2),result)
				pre0 = false
			end
		end 
		number = math.floor(number/10)
		i = i + 1
	end
	return result
end