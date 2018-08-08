--[[
	命名空间: xstr
	作者: apache(email: hqwemail@gmail.com; website: http: /  / hi.baidu.com / hqwfreefly)
	版本号: 0.1
	创建日期: 2010-10-17
	函数列表: trim, capitalize, count, startswith, endswith, expendtabs, isalnum, isalpha, isdigit, islower, isupper, 
			  join, lower, upper, partition, zfill, ljust, rjust, center, dir, help
	声明: 该软件为自由软件，遵循GPL协议。如果你需要为xstr增加函数，请在func_list中添加函数名，并在help函数中为其撰写帮助文档
	帮助: xstr:dir() 列出命名空间下的函数列表。xstr:help("func")查看func的帮助文档
--]]
module("THSTG.StringUtil", package.seeall)

func_list = "trim, capitalize, count, startswith, endswith, expendtabs, isalnum, isalpha, isdigit, islower, isupper, join, lower, upper, partition, zfill, ljust, rjust, center, dir, help"
--[[去除str中的所有空格。成功返回去除空格后的字符串，失败返回nil和失败信息]]
function trim(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	str = string.gsub(str, " ", "")
	return str
end

--[[将str的第一个字符转化为大写字符。成功返回转换后的字符串，失败返回nil和失败信息]]
function capitalize(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local ch = string.sub(str, 1, 1)
	local len = string.len(str)
	if ch < 'a' or ch > 'z' then
		return str
	end
	ch = string.char(string.byte(ch) - 32)
	if len == 1 then
		return ch
	else
		return ch .. string.sub(str, 2, len)
	end
end
--[[统计str中substr出现的次数。from, to用于指定起始位置，缺省状态下from为1，to为字符串长度。成功返回统计个数，失败返回nil和失败信息]]
function count(str, substr, from, to)
	if str == nil or substr == nil then
		return nil, "the string or the sub-string parameter is nil"
	end
	from = from or 1
	if to == nil or to > string.len(str) then
		to = string.len(str)
	end
	local str_tmp = string.sub(str, from, to)
	local n = 0
	for _, _ in string.gfind(str_tmp, substr) do
		n = n + 1
	end
	return n
end
--[[判断str是否以substr开头。是返回true，否返回false，失败返回失败信息]]
function startswith(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-stirng parameter is nil"
	end
	if string.find(str, substr) ~= 1 then
		return false
	else
		return true
	end
end
--[[判断str是否以substr结尾。是返回true，否返回false，失败返回失败信息]]
function endswith(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-string parameter is nil"
	end
	str_tmp = string.reverse(str)
	substr_tmp = string.reverse(substr)
	if string.find(str_tmp, substr_tmp) ~= 1 then
		return false
	else
		return true
	end
end
--[[使用空格替换str中的制表符，默认空格个数为8。返回替换后的字符串]]
function expendtabs(str, n)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	n = n or 8
	str = string.gsub(str, "\t", string.rep(" ", n))
	return str
end
--[[去掉字符串中的回车]]
function expendEnter(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	str = string.gsub(str, "\n", "")
	return str
end

--[[如果str仅由0-9，a-z，A-Z，-，_,组成，则返回true，否则返回false。失败返回nil和失败信息]]
function isValidCharacters(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9') or ch == "-" or ch == "_") then
			return false
		end
	end
	return true
end

--[[如果str仅由字母或数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
function isalnum(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9')) then
			return false
		end
	end
	return true
end
--[[如果str全部由字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
function isalpha(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z')) then
			return false
		end
	end
	return true
end
--[[如果str全部由数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
function isdigit(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if ch < '0' or ch > '9' then
			return false
		end
	end
	return true
end
--[[如果str全部由小写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
function islower(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if ch < 'a' or ch > 'z' then
			return false
		end
	end
	return true
end
--[[如果str全部由大写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
function isupper(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if ch < 'A' or ch > 'Z' then
			return false
		end
	end
	return true
end
--[[使用substr连接str中的每个字符，返回连接后的新串。失败返回nil和失败信息]]
function join(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-string parameter is nil"
	end
	local xlen = string.len(str) - 1
	if xlen == 0 then
		return str
	end
	local str_tmp = ""
	for i = 1, xlen do
		str_tmp = str_tmp .. string.sub(str, i, i) .. substr
	end
	str_tmp = str_tmp .. string.sub(str, xlen + 1, xlen + 1)
	return str_tmp
end
--[[将str中的小写字母替换成大写字母，返回替换后的新串。失败返回nil和失败信息]]
function lower(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	local str_tmp = ""
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if ch >= 'A' and ch <= 'Z' then
			ch = string.char(string.byte(ch) + 32)
		end
		str_tmp = str_tmp .. ch
	end
	return str_tmp
end
--[[将str中的大写字母替换成小写字母，返回替换后的新串。失败返回nil和失败信息]]
function upper(str)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	local len = string.len(str)
	local str_tmp = ""
	for i = 1, len do
		local ch = string.sub(str, i, i)
		if ch >= 'a' and ch <= 'z' then
			ch = string.char(string.byte(ch) - 32)
		end
		str_tmp = str_tmp .. ch
	end
	return str_tmp
end
--[[将str以substr（从左向右查找）为界限拆分为3部分，返回拆分后的字符串。如果str中无substr则返回str, '', ''。失败返回nil和失败信息]]
function partition(str, substr)
	if str == nil or substr == nil then
		return nil, "the string or the sub-string parameter is nil"
	end
	local len = string.len(str)
	local start_idx, end_idx = string.find(str, substr)
	if start_idx == nil or end_idx == len then
		return str, '', ''
	end
	return string.sub(str, 1, start_idx - 1), string.sub(str, start_idx, end_idx), string.sub(str, end_idx + 1, len)
end
--[[在str前面补0，使其总长度达到n。返回补充后的新串，如果str长度已经超过n，则直接返回str。失败返回nil和失败信息]]
function zfill(str, n)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	if n == nil then
		return str
	end
	local format_str = "%0" .. n .. "s"
	return string.format(format_str, str)
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[[设置str的位宽，默认的填充字符为空格。对齐方式为左对齐（rjust为右对齐，center为中间对齐）。返回设置后的字符串。失败返回nil和失败信息]]
function ljust(str, n, ch)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	ch = ch or "　"
	n = tonumber(n) or 0
	local len = string.len(str)
	return string.rep(ch, n - len) .. str
end

function rjust(str, n, ch)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	ch = ch or "　"
	n = tonumber(n) or 0
	local len = string.len(str)
	return str .. string.rep(ch, n - len)
end

function center(str, n, ch)
	if str == nil then
		return nil, "the string parameter is nil"
	end
	ch = ch or " "
	n = tonumber(n) or 0
	local len = string.len(str)
	rn_tmp = math.floor((n - len) / 2)
	ln_tmp = n - rn_tmp - len
	return string.rep(ch, rn_tmp) .. str .. string.rep(ch, ln_tmp)
end

-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function lua_string_split(str, split_char)
	local sub_str_tab = {};
	while (true) do
		local pos = string.find(str, split_char);
		if (not pos) then
			sub_str_tab[#sub_str_tab + 1] = str;
			break;
		end
		local sub_str = string.sub(str, 1, pos - 1);
		sub_str_tab[#sub_str_tab + 1] = sub_str;
		str = string.sub(str, pos + 1, #str);
	end

	return sub_str_tab;
end

--add by lqh
function getLength(str)
	return Fanren:getStringLength(str)
end

function getTextNewlineInfoByPixel(xOffset, contentWidth, content, fontSize)
	return Fanren:getTextNewlineInfoByPixel(xOffset, contentWidth, content, UI.FONT_FACE, fontSize)
end

--[[
@params seconds 总秒数
@params type  h:转换成小时  m:转换成分钟


eg: formatTime(61, "m") ==  > 01:01
eg: formatTime(3610, "h") ==  > 01:00:10
]]
function formatTime(seconds, type, formatText)
	if seconds < 0 then
		seconds = 0
	end
	local restSecond = math.mod(seconds, 60)
	local restMin = math.floor(seconds / 60)
	local finalStr = ""

	if not type or type == "m" then
		if restMin < 10 then
			restMin = 0 .. restMin
		end
		if restSecond < 10 then
			restSecond = 0 .. restSecond
		end
		formatText = formatText or "%s:%s"
		finalStr = string.format(formatText, restMin, restSecond)
	elseif type == "h" then
		local hour = math.floor(restMin / 60)
		local restMin = math.mod(restMin, 60)

		if hour < 10 then
			hour = 0 .. hour
		end
		if restMin < 10 then
			restMin = 0 .. restMin
		end
		if restSecond < 10 then
			restSecond = 0 .. restSecond
		end
		formatText = formatText or "%s:%s:%s"
		finalStr = string.format(formatText, hour, restMin, restSecond)
	end

	return finalStr
end

-- 判断名字是否合法
-- 弃用（12个英文字符名字太长）
-- function is_name_available(str, maxLength)
-- 	local cn_chars = {}
-- 	local en_chars = {}
-- 	for i = 1, string.len(str) do
-- 	    local c = string.byte(str, i)
-- 	    if c < 128 then --
-- 	        table.insert(en_chars, c)
-- 	    else
-- 	        table.insert(cn_chars, c)
-- 	    end
-- 	end

-- 	--
-- 	local cn_str = string.char(unpack(cn_chars))
-- 	local en_str = string.char(unpack(en_chars))
-- 	if type(maxLength) == "number" then
-- 	    local cn_len = StringUtil.getLength(cn_str)
-- 	    local en_len = string.len(en_str)
-- 	    if (maxLength * 2) < (cn_len * 2 + en_len) then
-- 	        -- 超出宽度（中文字符宽度为两个英文字符宽度）
-- 	        return false
-- 	    end
-- 	end

-- 	-- 含有非法英文字符
-- 	if string.find(en_str, "%W") then
-- 	    return false
-- 	end

-- 	-- 含有敏感字段
-- 	-- return false

--  	return true
-- end

-- 裁剪text，得到前面长度为length的字符串(支持非英文字符)
function clamp_text(str, length)
	if string.len(str) < length then
		return str
	end

	local len = 0
	local skip = 0
	local chars = {}

	for i = 1, string.len(str) do
		local c = string.byte(str, i)
		if i > skip then
			len = len + 1
			if c >= 128 then
				if c < 0xE0 then -- 2位utf8
					skip = i + 1

				elseif 0xE0 <= c and c < 0xF0 then -- 3位utf8
					skip = i + 2

				elseif 0xF0 <= c and c < 0xF8 then -- 4位utf8
					skip = i + 3

				end
			end
		end

		if len > length then
			break
		end

		table.insert(chars, c)
	end

	return string.char(unpack(chars))
end

-- 拆字text，得到一组字符
function getWords(str)
    local skip = 0
    local chars = {}
    local ret = {}
    for i = 1, string.len(str) do
        local c = string.byte(str, i)
        if i > skip then
            if #chars > 0 then
                table.insert(ret, string.char(unpack(chars)))
            end
            chars = {}
            if c >= 128 then
                if c < 0xE0 then -- 2位utf8
                    skip = i + 1

                elseif 0xE0 <= c and c < 0xF0 then -- 3位utf8
                    skip = i + 2

                elseif 0xF0 <= c and c < 0xF8 then -- 4位utf8
                    skip = i + 3

                end
            end
        end
        table.insert(chars, c)
    end
	if #chars > 0 then
	    table.insert(ret, string.char(unpack(chars)))
	end
    return ret
end
------------------------------------------------------------------------------------------------------------------------------------------
--[[显示xstr命名空间的所有函数名]]
function dir(self)
	print(self.func_list)
end
--[[打印指定函数的帮助信息, 打印成功返回true，否则返回false]]
function help(fun_name)
	man = {
		["trim"] = "xstr:trim(str) --> string | nil, err_msg\n  去除str中的所有空格，返回新串\n  print(xstr:trim(\"  hello wor ld \") --> helloworld",
		["capitalize"] = "xstr:capitalize(str) --> string | nil, err_msg\n  将str的首字母大写，返回新串\n  print(xstr:capitalize(\"hello\") --> Hello",
		["count"] = "xstr:count(str, substr [, from] [, to]) --> number | nil, err_msg\n  返回str中substr的个数, from和to用于指定统计范围, 缺省状态下为整个字符串\n  print(xstr:count(\"hello world!\", \"l\")) --> 3",
		["startswith"] = "xstr:startswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr开头, 是返回true，否返回false\n  print(xstr:startswith(\"hello world\", \"he\") --> true",
		["endswith"] = "xstr:endswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr结尾, 是返回true, 否返回false\n  print(xstr:endswith(\"hello world\", \"d\")) --> true",
		["expendtabs"] = "xstr:expendtabs(str, n) --> string | nil, err_msg\n  将str中的Tab制表符替换为n格空格，返回新串。n默认为8\n  print(xstr:expendtabs(\"hello	world\")) --> hello        world",
		["isalnum"] = "xstr:isalnum(str) --> boolean | nil, err_msg\n  判断str是否仅由字母和数字组成，是返回true，否返回false\n  print(xstr:isalnum(\"hello world:) 123\")) --> false",
		["isalpha"] = "xstr:isalpha(str) --> boolean | nil, err_msg\n  判断str是否仅由字母组成，是返回true，否返回false\n  print(xstr:isalpha(\"hello WORLD\")) --> false",
		["isdigit"] = "xstr:isdigit(str) --> boolean | nil, err_msg\n  判断str是否仅由数字组成，是返回true，否返回false\n  print(xstr:isdigit(\"0123456789\")) --> true",
		["islower"] = "xstr:islower(str) --> boolean | nil, err_msg\n  判断str是否全部由小写字母组成，是返回true，否返回false\n  print(xstr:islower(\"hello world\")) --> false",
		["isupper"] = "xstr:isupper(str) --> boolean | nil, err_msg\n  判断str是否全部由大写字母组成，是返回true，否返回false\n  print(xstr:isupper(\"HELLO WORLD\")) --> false",
		["join"] = "xstr:join(str, substr) --> string | nil, err_msg\n  使用substr连接str中的每个元素，返回新串\n  print(xstr:join(\"hello\", \"--\")) --> h--e--l--l--o",
		["lower"] = "xstr:lower(str) --> string | nil, err_msg\n  将str中的大写字母小写化，返回新串\n  print(xstr:lower(\"HeLLo WORld 2010\")) --> hello wold 2010",
		["upper"] = "xstr:upper(str) --> string | nil, err_msg\n  将str中的小写字母大写化，返回新串\n  print(xstr:upper(\"hello world 2010\")) --> HELLO WORLD 2010",
		["partition"] = "xstr:partition(str, substr) --> string, string, string | nil, err_msg\n  将str按照substr为界限拆分为3部分，返回拆分后的字符串\n  print(xstr:partition(\"hello*world\", \"wo\")) --> hello*	wo	rld",
		["zfill"] = "xstr:zfill(str, n) --> string | nil, err_msg\n  在str前补0，使其总长度为n。返回新串\n  print(xstr:zfill(\"100\", 5)) --> 00100",
		["ljust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按左对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:ljust(\"hello\", 10, \"*\")) --> *****hello",
		["rjust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按右对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:rjust(\"hello\", 10, \"*\")) --> hello*****",
		["center"] = "xstr:center(str, n, ch) --> string | nil, err_msg\n  按中间对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:center(\"hello\", 10, \"*\")) --> **hello***",
		["dir"] = "xstr:dir()\n  列出xstr命名空间中的函数",
		["help"] = "xstr:help(\"func\")\n  打印函数func的帮助文档\n  xstr:help(\"dir\") --> \nxstr:dir()\n  列出xstr命名空间中的函数",
	}
	print(man[fun_name])
end

--获取子字符串,一个中文字符按1长度计算
function getSubStringCN(str, b, l)
	b = b or 1

	local lenInByte = #str
	local width = 0
	local charStore = {}

	local tmpi = 1
	for i = 1, lenInByte do
		if tmpi <= i then
			local curByte = string.byte(str, i)
			local byteCount = 1;
			if curByte > 0 and curByte <= 127 then
				byteCount = 1
			elseif curByte >= 192 and curByte < 223 then
				byteCount = 2
			elseif curByte >= 224 and curByte < 239 then
				byteCount = 3
			elseif curByte >= 240 and curByte <= 247 then
				byteCount = 4
			end

			local char = string.sub(str, i, i + byteCount-1)
			tmpi = tmpi + byteCount

			charStore[#charStore + 1] = char
		end
	end
	l = l or #charStore

	local sub = ""
	for i = 1, l do
		if i + b-1 > #charStore then
			break
		end

		sub = sub..charStore[i + b-1]
	end
	return sub, #charStore

end

-- add by wangchao -----------------------------------------------
function transTime(time)
	local day = math.floor(time / 3600 / 24)
	local hour = math.floor(time / 3600 % 24)
	local min = math.floor(time / 60 % 60)
	local sec = math.floor(time % 60)

	return day, hour, min, sec
end

local timeStr = "%d天%d时%d分%d秒"
function transDayTimeStr(time)
	local day = math.floor(time / 3600 / 24)
	local hour = math.floor(time / 3600 % 24)
	local min = math.floor(time / 60 % 60)
	local sec = math.floor(time % 60)

	return string.format(timeStr, day, hour, min, sec)
end


-- 转换成 h:m:s 或者 m:s
function transTimeStr(time, type)

	local b = math.floor(time / 3600)
	local c = math.floor(time / 60 % 60)
	local d = math.floor(time % 60)

	local bStr = ""
	local cStr = ""
	local dStr = ""


	local tmp = false
	if type == "h" then
		tmp = true
	end

	if tmp or b >= 0 then
		bStr = tostring(b)
		if b < 10 then
			bStr = "0" .. bStr
		end
		bStr = bStr .. ":"
	end

	if c >= 0 then
		cStr = tostring(c)
		if c < 10 then
			cStr = "0" .. cStr
		end
		cStr = cStr .. ":"
	end

	if d >= 0 then
		dStr = tostring(d)
		if d < 10 then
			dStr = "0" .. dStr
		end
		dStr = dStr
	end

	local str = bStr .. cStr .. dStr
	return str
end

function transCopyTimeStr(time, type)

	local b = math.floor(time / 3600)
	local c = math.floor(time / 60 % 60)
	local d = math.floor(time % 60)

	local bStr = ""
	local cStr = ""
	local dStr = ""

	if b > 0 then
		bStr = tostring(b)
		if b < 10 then
			bStr = "0" .. bStr
		end
		bStr = bStr .. ":"
	end

	cStr = tostring(c)
	if c < 10 then
		cStr = "0" .. cStr
	end
	cStr = cStr .. ":"

	dStr = tostring(d)
	if d < 10 then
		dStr = "0" .. dStr
	end
	dStr = dStr

	local str = bStr .. cStr .. dStr

	return str
end

local activityTimeStr = 
{
	[200807] = "本轮活动倒计时：%s",
	[200808] = "%s天%s时%s分%s秒",
	[200809] = "%s天",
	[200810] = "%s时",
	[200811] = "%s分",
	[200812] = "%s秒",
}

function transActivityTime(time)
	local b = math.floor(time / 3600)
	local c = math.floor(time / 60 % 60)
	local d = math.floor(time % 60)
	local bStr = ""
	local cStr = ""
	local dStr = ""

	if b > 0 then
		bStr = tostring(b)
		if b < 10 then
			bStr = "0" .. bStr
		end
		bStr = string.format(activityTimeStr[200810],bStr)
	end

	cStr = tostring(c)
	if c < 10 then
		cStr = "0" .. cStr
	end
	cStr = string.format(activityTimeStr[200811],cStr)

	dStr = tostring(d)
	if d < 10 then
		dStr = "0" .. dStr
	end
	dStr = string.format(activityTimeStr[200812],dStr)

	local str = bStr..cStr..dStr

	return str
end

function transActivityTimeStr(time, type)

	local a = math.floor(time / (3600*24))
	local b = math.floor(time / 3600 % 24)
	local c = math.floor(time / 60 % 60)
	local d = math.floor(time % 60)

	local aStr = ""
	local bStr = ""
	local cStr = ""
	local dStr = ""

	if a > 0 then
		aStr = tostring(a)
		if a < 10 then
			aStr = "0" .. aStr
		end
		aStr = string.format(activityTimeStr[200809],aStr)
	end

	if b > 0 then
		bStr = tostring(b)
		if b < 10 then
			bStr = "0" .. bStr
		end
		bStr = string.format(activityTimeStr[200810],bStr)
	end

	cStr = tostring(c)
	if c < 10 then
		cStr = "0" .. cStr
	end
	cStr = string.format(activityTimeStr[200811],cStr)

	dStr = tostring(d)
	if d < 10 then
		dStr = "0" .. dStr
	end
	dStr = string.format(activityTimeStr[200812],dStr)

	local str = aStr..bStr..cStr..dStr

	return str
end

--默认显示完 天：时：分：秒
function transActivityTimeStrShowControl(time, type)

	local a = math.floor(time / (3600*24))
	local b = math.floor(time / 3600 % 24)
	local c = math.floor(time / 60 % 60)
	local d = math.floor(time % 60)

	local aStr = ""
	local bStr = ""
	local cStr = ""
	local dStr = ""

	
	aStr = tostring(a)
	if a < 10 then
		aStr = "0" .. aStr
	end
	aStr = string.format(activityTimeStr[200809],aStr)

	bStr = tostring(b)
	if b < 10 then
		bStr = "0" .. bStr
	end
	bStr = string.format(activityTimeStr[200810],bStr)
	

	cStr = tostring(c)
	if c < 10 then
		cStr = "0" .. cStr
	end
	cStr = string.format(activityTimeStr[200811],cStr)

	dStr = tostring(d)
	if d < 10 then
		dStr = "0" .. dStr
	end
	dStr = string.format(activityTimeStr[200812],dStr)
	local str = aStr..bStr..cStr..dStr
	if type == "d" then
		str = aStr
	elseif type == "h" then
		str = aStr..bStr
	elseif type == "m" then
		str = aStr..bStr..cStr
	end
	return str
end

local timeText =
{
	-- 时间
	[100080] = "天",
	[100081] = "时",
	[100082] = "分",
	[100083] = "秒",
	[100084] = "小时",
}
function transTimeText(time)

	local a, b, c, d = transTime(time)
	local aText = ""
	local bText = ""
	local cText = ""
	local dText = ""
	if a > 0 then
		aText = a .. string.format(timeText[100080])
	end
	if b > 0 then
		bText = b .. string.format(timeText[100084])
	end
	if c > 0 then
		cText = c .. string.format(timeText[100082])
	end
	if true or d > 0 then
		dText = d .. string.format(timeText[100083])
	end
	local text = aText .. bText .. cText .. dText

	return text
end


local chnNum =
{
	[0] = "零",
	[1] = "一",
	[2] = "二",
	[3] = "三",
	[4] = "四",
	[5] = "五",
	[6] = "六",
	[7] = "七",
	[8] = "八",
	[9] = "九",
	[10] = "十",
}

-- 字符串 转 字符串
-- 阿拉伯0-99 转换 中文
function transNumToChnNum(num)
	if num == nil then
		return ""
	end
	if type(num) == "string" then
		num = tonumber(num)
	end
	if num >= 0 and num <= 10 then
		return chnNum[num]
	elseif num > 10 and num <= 19 then
		local ge = num % 10
		return chnNum[10] .. chnNum[ge]
	elseif num >= 20 and num < 100 then
		local shi = math.floor(num / 10)
		local shiStr = chnNum[shi]

		local ge = num % 10
		local geStr = ""
		if ge > 0 then
			geStr = chnNum[ge]
		end
		return shiStr .. chnNum[10] .. geStr
	end
	return ""
end


--YYYY-MM-DD hh:mm:ss
function getTimeByString(dateStr)
	--从日期字符串中截取出年月日时分秒
	local Y = string.sub(dateStr, 1, 4)
	local M = string.sub(dateStr, 6, 7)
	local D = string.sub(dateStr, 9, 10)
	local h = string.sub(dateStr, 12, 13)
	local m = string.sub(dateStr, 15, 16)
	local s = string.sub(dateStr, 18, 19)

	--把日期时间字符串转换成对应的日期时间
	local time = os.time{year = Y, month = M, day = D, hour = h, min = m, sec = s}

	return time or 0
end

--hh:mm:ss
function getTimeByString2(dateStr)
	--从日期字符串中截取出时分秒
	local datas = string.split(dateStr,":")
	
	local h = #datas >= 3 and 3600 
	local m = #datas >= 2 and 60
	local s = #datas >= 1 and 1
	local time = 0
	for k,v in ipairs(datas) do 
		if h then 
			time = time + tonumber(v) * h
			h = false
			
		elseif m then 
			time = time + tonumber(v) * m
			m = false
			
		elseif s then 
			time = time + tonumber(v) * s
			s = false
		end
	end

	return time 
end


local unitChar =
{
	[0] = "万",
    [1] = "亿",
}
function transValue(value)
	if value >= 1 then
		if value >= 100000000 then
			value = string.format("%.2f%s", value / 100000000, unitChar[1])
		elseif value >= 10000 then
			value = string.format("%.2f%s", value / 10000, unitChar[0])
		end
	else
		value = 0
	end
	return tostring(value)
end
--解析像456,656#556,45 的字符串成table
--[[
 str 		原字符串
 splitTb 	分隔符列表 
 fields		生成字段名列表
--
 ex:
  conditTb = stringParser(condit,{"#",","},{
					{name = "equipType",isString = true},
					{name = "color"}
				})
]]--
function stringSplitParser(str,splitTb,fields)
	local result = {}
	local function loop(str,index)
		local splitWord = splitTb[index]
		if splitWord == "" then
			if fields[1].isString then
				return  str
			else
				return tonumber(str)
			end 
		end 
		local tb = string.split(str,splitWord)
		local result = {}
		if index+1 <= #splitTb then
			for i,v in ipairs(tb) do
				if v ~= "" then
					table.insert(result,loop(v,index+1))
				end 
			end
		else
			local fieldCount = math.min(#fields,#tb)
			for i=1,fieldCount do
				local isString = fields[i].isString
				local fieldName = fields[i].name
				local value = tb[i]
				if not isString then
					value = tonumber(value)
				end 
				result[fieldName] = value
			end
		end  
		return result
	end
	return loop(str,1)
end

-- 可用单词列表
local _volidChars = {}
-- 0-9
for i=48, 57 do
	table.insert(_volidChars, string.char(i))
end
-- A-Z
for i=65, 90 do
	table.insert(_volidChars, string.char(i))
end
-- _
table.insert(_volidChars, string.char(95))
-- a-z
for i=97, 122 do
	table.insert(_volidChars, string.char(i))
end
-- 获取一个随机合法关键字
function getRandomKeyWord()
	local tmpT = {_volidChars[math.random(38, #_volidChars)]}
	while true do
		local len = #tmpT
		if len >= 5 or math.random() < 0.2 then
			break
		end
		tmpT[len+1] = _volidChars[math.random(1, #_volidChars)]
	end
	return table.concat(tmpT)
end


