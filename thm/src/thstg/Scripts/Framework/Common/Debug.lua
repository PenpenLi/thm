-- 是否打印 下推命令
__PRINT_PUSH__ = false

-- 是否打印 请求命令
__PRINT_REQUEST__ = false

-- 是否打印 回调命令
__PRINT_RESPONSE__ = false

-- 是否打印 按钮点击回调的文件位置
__PRINT_ONCLICK__ = true

-- 是否打印 控件创建时的堆栈
__PRINT_TRACK__ = false

-- 是否打印 ccnode节点创建时的堆栈
__PRINT_NODE_TRACK__ = false

-- 颜色，测出无用的颜色
__DEBUG_COLOR__ = false

-- 资源，测出无用的资源
__DEBUG_RESOURCES__ = false

__DEBUG_TRACE_BACK__ = false

-------------------------------------------------
CCPrint = _G.print	--貌似下面的不好使
--local logFunc = CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID and LuaLogE or LuaLog
local logFunc = CCPrint

--打印
if not __DEBUG__ then
	print = function (...) end
else
	print = function (...)
		local args = {...}
		local count = #args
		if count <= 0 then return end

		local fromIndex = 1
		if __PRINT_TYPE__ > 0 then
			fromIndex = 2
			if args[1] ~= __PRINT_TYPE__ then return end
		end

		local msg = ""
		if __PRINT_WITH_FILE_LINE__ then
			local traceback = string.split(debug.traceback("", 2), "\n")
			msg = string.format("print from: %s\n", string.trim(traceback[3]))
		end
		for i = fromIndex, count do
			msg = string.format("%s%s ", msg, tostring(args[i]))
		end
		logFunc(msg)
	end
end

--打印table
function printTable(...)
	if not __DEBUG__ then return end

	local args = {...}
	local fromIndex = 1
	if __PRINT_TYPE__ > 0 then
		if args[1] ~= __PRINT_TYPE__ then return end
		fromIndex = 2
	end
	if __PRINT_WITH_FILE_LINE__ then
		local traceback = string.split(debug.traceback("", 2), "\n")
		logFunc(string.format("print from: %s\n", string.trim(traceback[3])))
	end
	for i = fromIndex, #args do
		local root = args[i]
		if type(root) == "table" then
			local temp = {
				"----------------printTable start----------------------------\n",
				tostring(root).."={\n",
			}
			local function table2String(t, depth)
				if type(depth) == "number" then
					depth = depth + 1
				else
					depth = 1
				end
				local indent = ""
				for i = 1, depth do
					indent = indent .. "\t"
				end

				for k, v in pairs(t) do
					local key = tostring(k)
					if tonumber(key) then
						key = "["..key.."]"
					end
					local typeV = type(v)
					if typeV == "table" then
						if key ~= "__valuePrototype" then
							table.insert(temp, indent..key.."={\n")
							table2String(v, depth)
							table.insert(temp, indent.."},\n")
						end
					elseif typeV == "string" then
						table.insert(temp, string.format("%s%s=\"%s\",\n", indent, key, tostring(v)))
					else
						table.insert(temp, string.format("%s%s=%s,\n", indent, key, tostring(v)))
					end
				end
			end
			table2String(root)
			table.insert(temp, "}\n------------------------printTable end------------------------------")
			logFunc(table.concat(temp))
		else
			logFunc(tostring(root))
		end
	end
end

function dumpTable(printType, value, desciption, nesting)
    --DEBUG的宏
    if __PRINT_TYPE__ > 0 and printType ~= __PRINT_TYPE__ then
        return
    end

    if not __DEBUG__ then
        return 
    end

    if type(nesting) ~= "number" then nesting = 25 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    result[#result +1 ] = "dump from: " .. string.trim(traceback[3])

    local function dump_value_(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}

                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end

                    --针对cdl结构做特殊处理，使打印的数据可读性更高
                    if value.__cname ~= nil and 
                        (k == "__keyPrototype" or k == "__keyBase" or k == "__valuePrototype" or k == "__valueBase") then
                        local typeV = type(v)
                        if typeV ~= "table" then
                            values[k] = tostring(v)
                        else
                            values[k] = v.name
                        end
                    else
                        values[k] = v
                    end
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "", 1)
    logFunc((table.concat(result, "\n")))
end

function getTraceback(fromLevel)

	local ret = ""
	local level = 2
	if type(fromLevel) == "number" and fromLevel >= 0 then
		level = fromLevel + 2
	end

	while true do
		--get stack info
		local info = debug.getinfo(level, "Sln")
		if not info then
			break
		else
			if ret ~= "" then
				ret = ret .. "\r\n"
			end
			ret = string.format("%s[%s]:%d in %s \"%s\"", ret, info.source, info.currentline, info.namewhat ~= "" and info.namewhat or "''", info.name or "")
		end

		--打印变量
		-- local i = 1
		-- while true do
		-- 	local name, value = debug.getlocal(level, i)

		-- 	if not name then break end

		-- 	ret = ret .. "\t" .. name .. " =\t" .. tostringex(value, 3) .. "\n"
		-- 	i = i + 1
		-- end

		level = level + 1
	end

	ret = string.format("-------------------- Traceback --------------------\n%s", ret)

	return ret
end

--打印当前函数的调用堆栈
function printTraceback(fromLevel)
	if(__DEBUG_TRACE_BACK__)then
		logFunc(__PRINT_TYPE__, getTraceback(fromLevel))
	end
end

-- 打印函数的信息
function printStack(func)
	if __PRINT_ONCLICK__ then
		func = func or 2
		print (__PRINT_TYPE__, "##COLOR##5##",
			debug.getinfo(func).source,
			debug.getinfo(func).linedefined,
			debug.getinfo(func).lastlinedefined)
	end
end

-- lua脚本监听清除loaded
function restoreLoaded()
	if cc.exports.__packageLoaded == nil then
		cc.exports.__packageLoaded = {}
		for k, _ in pairs(package.loaded) do
			cc.exports.__packageLoaded[k] = true
		end
	else
		for k, _ in pairs(package.loaded) do
			if not cc.exports.__packageLoaded[k] then
				package.loaded[k] = nil
			end
		end
	end
end

-- 调试节点
-- 显示node的contentSize和anchorPoint
function debugUI(node)
	assert(node and tolua.cast(node, "cc.Node"), "debugUI(): node is unavailable")

	local tag = 9231287464
	local drawer = node:getChildByTag(tag)
	if not drawer then
		drawer = cc.DrawNode:create()
		drawer:setTag(tag)
		node:addChild(drawer)
	else
		drawer:clear()
	end

	local color = cc.c4f(1, 0, 0, 1)
	local size = node:getContentSize()
	drawer:drawRect(cc.p(0, 0), cc.p(size.width, size.height), color)

	local anchor = node:getAnchorPoint()
	local x, y = anchor.x * size.width, anchor.y * size.height
	drawer:drawDot(cc.p(x, y), 5, color)
end

-- 调试函数调用的细节
function debugFunction(func, log)
	debugModuleBegin()
	------------------------------
	func()
	------------------------------
	debugModuleEnd()
end

local s_hookData = false
function debugModuleBegin()
	if rawget(_G, "profiler_start") then
		--C++ 统计时间异步处理打印
		rawget(_G, "profiler_start")()
	else
		if s_hookData then
			return
		end

		s_hookData = {
			hookTime = 0,
			func = {},
			call = {},
			self = {},
			selfLast = {},
		}
		local function hookf(type)
			if type == "count" then
				s_hookData.hookTime = s_hookData.hookTime + 1
				local info = debug.getinfo(2, "Sln")
				local name = string.format("%s[%d", info.source, info.linedefined)
				s_hookData.self[name] = (s_hookData.self[name] or 0) + 1
			elseif type == "return" then
				local level = 2
				local line = 0
				local checkRepeat = {}
				while true do
					local info = debug.getinfo(level, "Sln")
					if not info then
						break
					else
						if info then
							if level == 2 then
								local key = string.format("%s[%d", info.source, info.linedefined)
								s_hookData.call[key] = (s_hookData.call[key] or 0) + 1
								line = s_hookData.self[key] - (s_hookData.selfLast[key] or 0)
								s_hookData.selfLast[key] = s_hookData.self[key]
							end

							local name = string.format("%s[%d~%d]%s[%d]", info.source, info.linedefined, info.lastlinedefined, info.name, info.currentline)
							if not checkRepeat[name] then
								s_hookData.func[name] = (s_hookData.func[name] or 0) + line
								checkRepeat[name] = true
							end
						end
					end
					level = level + 1
				end
			end
		end
		LuaLog("======== debugModuleBegin ========")
		debug.sethook(hookf, "r", 1)
	end
end

function debugModuleEnd()
	if rawget(_G, "profiler_stop") then
		rawget(_G, "profiler_stop")()
	else
		debug.sethook()
		if not s_hookData then
			return
		end
		LuaLog("======== debugModuleEnd ========")
		LuaLog("== total hooks:", s_hookData.hookTime, "==")

		local t = {}
		for k, v in pairs(s_hookData.func) do
			local call = 1
			local pos = string.find(k, "~")
			if pos then
				local ck = string.sub(k, 1, pos - 1)
				call = s_hookData.call[ck] or 1
			end
			table.insert(t, {
				name = k,
				hooks = v,
				calls = call,
				hooksPreCall = math.floor(v / call),
			})
		end
		table.sort(t, function(a, b)
			return a.hooks > b.hooks
		end)
		LuaLog("| hooks | hooks pre call | call | location |")
		for i = 1, 90 do
			local v = t[i]
			if not v then
				break
			end
			LuaLog("::", v.hooks, v.hooksPreCall, v.calls, v.name)
		end
		s_hookData = false
	end
end
