module("TableUtil", package.seeall)


-- 如果a和b的key值都有，a的值会覆盖b的值。
-- 得到新的tb，不改变原来的a和b。
function mergeTable(a, b, isInit)
	if isInit == nil then
		-- a = clone(a)
		b = clone(b)
	end
	if a == nil then return b end
	if type(b) == "table" and type(a) == "table" then
		for k, v in pairs(b) do
			b[k] = mergeTable(a[k], b[k], false)
		end
		return b
	else
		return a
	end
end

-- 如果a和b的key值都有，a的值会覆盖b的值。
-- 如果key值，b没有，a有，则将key值赋给新的tb，
-- 得到新的tb，不改变原来的a和b。
function mergeAllTable(a, b, isInit)
	if isInit == nil then
		a = clone(a)
		b = clone(b)
	end
	if a == nil then return b end
	if type(b) == "table" and type(a) == "table" then
		for k, v in pairs(b) do
			b[k] = mergeAllTable(a[k], b[k], false)
		end
		for k, v in pairs(a) do
			if b[k] == nil then
				b[k] = v
			end
		end
		return b
	else
		return a
	end
end

--[[
将a，b两者融合，如果有a则值为a，否则值为b(注意,B中不能有值为nil的字段,否则无法融合)
如：
a = {a = 1, b = {c = 1}, e = "aaa"}
b = {a = 2, b = {c = 2, d = "ddd"}, e="eee"}
local c = TableUtil.mergeA2B(a, b) --c = {a=1, b={c=1, d="ddd"}, e="aaa"}
]]
function mergeA2B(a, b)
	if a == nil then return b end
	if type(b) == "table" and type(a) == "table" then
		for k, v in pairs(b) do
			b[k] = mergeA2B(a[k], b[k])
		end
		return b
	else
		return a
	end
end

--[[
	取a、b的并集，某个字段同时存在，取a中该字段的值
]]
function unionA2B(a, b)
	if a == nil then return b end
	if type(b) == "table" and type(a) == "table" then
		for k, v in pairs(a) do
			b[k] = unionA2B(a[k], b[k])
		end
		return b
	else
		return a
	end
end

--[[
将一个table数组的内容随机排序(不改变原数组，返回一个新的数组)
@param	tbl		[table]		数组
@return [table]	返回一个已乱序的新数组
]]
function randomSortArray(tbl)
	local indexes = {}
	for i = 1, #tbl do
		indexes[i] = i
	end

	local randomIndexes = {}
	while #indexes > 0 do
		table.insert(randomIndexes, table.remove(indexes, math.random(1, #indexes)))
	end

	local result = {}
	for k, v in ipairs(randomIndexes) do
		result[k] = tbl[v]
	end

	return result
end

--把table格式化成string，与string2table结合使用
function table2string(tbl)
	if type(tbl) ~= "table" then return tostring(tbl) end

	local strTbl = {}
	for k, v in pairs(tbl) do
		local tmpStr = (type(k) == "number" and ("[" .. k .. "]") or tostring(k)) .. "="
		if type(v) == "table" then
			tmpStr = tmpStr .. table2string(v)
		elseif type(v) == "string" then
			tmpStr = tmpStr .. "'"..tostring(v).."'"
		else
			tmpStr = tmpStr .. tostring(v)
		end
		table.insert(strTbl, tmpStr)
	end

	if #strTbl > 0 then
		return string.format("{%s}", table.concat(strTbl, ","))
	end

	return ""
end

--把string格式化为table，与table2string结合使用
function string2table(str)
	return loadstring("return " .. str)()
end

--[[
对数组进行真实排序
@param	tbl			要排序的数组
@param	sortFunc	排序函数
@example
根据数组项中m的值从大到小进行排序，原本在前的依旧排前
local tbl = {
	{m = 1, n = 2}, 
	{m = 7, n = 2}, 
	{m = 4, n = 1}, 
	{m = 2, n = 2}, 
	{m = 1, n = 5}, 
}
local function sortFunc(a, b)
	if a.value.m > b.value.m then
		return true
	elseif a.value.m < b.value.m then
		return false
	else
		if a.index > b.index then
			return true
		else
			return false
		end
	end
end
TableUtil.realSort(tbl, sortFunc)
]]
function realSort(tbl, sortFunc)
	if type(tbl) ~= "table" or #tbl < 2 then return end

	local tmpTbl = {}
	for k, v in ipairs(tbl) do
		tmpTbl[k] = {index = k, value = v}
	end
	table.sort(tmpTbl, sortFunc)
	for k, v in ipairs(tmpTbl) do
		tbl[k] = v.value
	end
end

--逆序表对象
function reverseTable(tbl)
	local newTbl = {}
	for i = #tbl, 1, -1 do
		table.insert(newTbl, tbl[i])
	end
	return newTbl
end


--[[
	从[x0, y0][x1, y1]...解析点坐标
--]]
function getPointFromTblParam(param)
	local x = string.gsub(param, "%[(%d+),%d+%][%[%d+,%d+%]]*","%1")
	local y = string.gsub(param, "%[%d+,(%d+)%][%[%d+,%d+%]]*","%1")
	x = tonumber(x)
	y = tonumber(y)
	if x and y then
		return {x = x, y = y}
	end
end

function getSPointArrayFromTbl(param)
	local seqPoint = Message.Public.SeqPoint.new()
	while(param and param ~= "") do
		local point = getPointFromTblParam(param)
		if point then
			local spoint = Message.Public.SPoint.new()
			spoint.x_SH = point.x
			spoint.y_SH = point.y
			seqPoint:pushBack(spoint)
		end
		param = string.gsub(param, "%[%d+,%d+%]([%[%d+,%d+%]]*)","%1")
	end
	return seqPoint:getArray()
end

function getPointsFromTbl(param)
	local points = {}

	while(param and param ~= "") do
		local point = getPointFromTblParam(param)
		if point then
			table.insert(points, point)
		end
		param = string.gsub(param, "%[%d+,%d+%]([%[%d+,%d+%]]*)","%1")
	end
	return points
end

--[[
params fun  [function(k, v)]
params key   
params value
Params ret  
params ary     数组
params table   表
]]
function tableFind(params)
	params = params or {}
	if type(params.ary) ~= "table" and type(params.table) ~= "table" then
		return nil
	end
	local function fun(k, v)
		if type(params.fun) == "function" then
			return params.fun(k, v, params)
		elseif params.key and params.value then
			return params.key == k and params.value == v
		elseif params.key then
			return params.key == k
		elseif params.value then
			return params.value == v
		end
	end
	if params.table then
		for k, v in pairs(params.table) do
			if fun(k, v) then
				if type(params.ret) == "function" then
					return params.ret(k, v)
				end
				return v, k
			end
		end
	else
		for k, v in ipairs(params.ary) do
			if fun(k, v) then
				if type(params.ret) == "function" then
					return params.ret(k, v)
				end
				return v, k
			end
		end
	end
end

--合并n个table
function mergeNTable(...)
	local whole = {}
	local params={...}
	-- dump(77, params)
	for i = 1, #params do
		for _, v in pairs(params[i])do
			table.insert(whole, #whole + 1, v)
		end
	end
	return whole
end

--是否为空表
function isTableEmpty(t)
	return _G.next(t) == nil
end


--生成枚举
function creatEnum(tbl, index) 
    assert(IsTable(tbl)) 
    local enumtbl = {} 
    local enumindex = index or 0 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i 
    end 
    return enumtbl 
end 

--安全取得key内容
function safeGetValue(default,table,...)
	local params = {...}
	if table then
		if type(table) == "table" then
			local value = table
			for i,v in pairs(params) do
				value = value[v]
				if not value then
					return default
				end
			end
			return value
		end
	end
	return default
end
--安全移除,解决在循环中移除造成的错位问题
function safeRemoveItem(list, item, removeAll)
	local rmCount = 0
	local defaultFunc = function (v)
		return v == item
	end

	if type(item) == "function" then
		defaultFunc = item
	end

	for i = 1, #list do
		if defaultFunc(list[i - rmCount]) then
			table.remove(list, i - rmCount)
			if removeAll then
				rmCount = rmCount + 1
			else
				break
			end
		end
	end
end

--pairs顺序遍历 table(按key从小到大遍历) 
--迭代器
function pairsByKeys(t,desc)
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
	table.sort(a,function (a,b)
		if desc then return (a > b)
		else return (a < b)
		end
    end)
    local i = 0
    return function()
	    i = i + 1
	    return a[i], t[a[i]]
    end
end

--取得table真实长度
function getLength(t)
	local length = 0
	for _,_ in pairs(t) do length = length + 1 end
	return length
end

--创建enum
function newEnums(tbl, index) 
    local enumtbl = {} 
    local enumindex = index or 0 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i 
    end 
    return enumtbl 
end
