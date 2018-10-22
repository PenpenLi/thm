--正在调用中的全局接口，需要在切换帐号时清除
_G.__INVOKING_INTERFACES__ = {}

--用于保存的接口key
local function getInterfaceKey(proxy, funcName)
	return string.format("%s_%s", proxy, funcName)
end

local M = class("Proxy")

--[[]
-- 需要初始化proxy类
function M:ctor()
	self._defaultProxy = "IGuild"
end
--]]

function M:ctor()
	--默认使用的proxy名，待子类覆盖重写，类型：string
	self._defaultProxy = false
end

--[[
-- 调用服务端接口
-- params参数如下：
-- session    		#session		默认为GateSession
-- proxy	    	#string			[必须]指定对应Session里注册的proxy
-- funcName			#string			[必须]接口函数名
-- onSuccess		#function		成功回调函数
-- onFailed			#function		失败回调函数
-- hasResponse 		#boolean		是否有返回值，默认为false
-- limitCall		#boolean		是否限制接口调用，默认为false，为true时当接口调用未回调成功或失败期间无法再次调用该接口
-- ...	对应params.rmi接口函数中的各项参数
eg: 
	self:invoke(
		{
			session = SessionManager.getLoginSession(), 
			proxy = "loginProxy", 
			funcName = "login_async", 
			onSuccess = function ()
			end, 
			onFailed = function (code, what)
			end, 
}, 
	...
)
]]
function M:invoke(params, ...)

	assert(type(params) == "table", "[Proxy] invoke params must be a table!")
	assert(type(params.funcName) == "string", "[Proxy] invoke params.funcName must be a string(function name)!")
	if not self._defaultProxy and type(params.proxy) ~= "string" then
		assert(false, "[Proxy] invoke params.proxy must be a string(proxy name)!")
	end

	local session = params.session or SessionManager.getGateSession()

	if not session then 
		print("session已经关闭")
		return 
	end

	local proxy = params.proxy or self._defaultProxy

	if params.limitCall == true and _G.__INVOKING_INTERFACES__[getInterfaceKey(proxy, params.funcName)] ~= nil then
		return
	end

	local paramsRecord = {...}

	local function delegatePrint( )
		if __PRINT_TYPE__ == 456 then
			local toPrint = {}
			table.insert(toPrint,proxy )
			table.insert(toPrint,params.funcName)
			for i,v in ipairs(paramsRecord) do
				if type(v) == 'table' then
					local cloneV = shallowClone(v)
					table.insert(toPrint,json.encode(cloneV))
				else
					table.insert(toPrint,tostring(v))
				end
			end
			local printStr = table.concat(toPrint,"·")
			print(__PRINT_TYPE__,"##COLOR##15##","===请求：===",printStr)
		end
	end

	local realProxy = session[proxy]
	if realProxy then
		local func = realProxy[params.funcName]
		if func then

			local beginTime = millisecondNow()
			local function clearInvokeFlag()
				if params.limitCall == true then
					_G.__INVOKING_INTERFACES__[getInterfaceKey(proxy, params.funcName)] = nil
				end
			end

			local function successCallback()
				clearInvokeFlag()

				if params.onSuccess then
					if params.hasResponse then
						params.onSuccess(self:__getResponse(proxy, params.funcName))
					else
						params.onSuccess()
					end
				end
				Dispatcher.dispatchEvent(EventType.LOGIN_PROXY_RESPONSE)

				local endTime = millisecondNow()
				Cache.serverTimeCache.setDelayTime(endTime - beginTime)

				delegatePrint()
			end

			local function failedCallback(code, what)
				MsgManager.systemException(code, what)

				clearInvokeFlag()
				if params.onFailed then
					params.onFailed(code, what)
				end

				if code == 20003 then
					Dispatcher.dispatchEvent(EventType.LOGIN_PROXY_TIMEOUT)
				else
					Dispatcher.dispatchEvent(EventType.LOGIN_PROXY_RESPONSE)
				end
			end

			if __PRINT_REQUEST__ then

				if type(params.proxy) == "string" and type(params.funcName) == "string" then
					local filter = {
						-- ["confirmPackage_async"] = true,
						-- ["getLimitBuyInfo_async"] = true,
					}
					if not filter[params.funcName] then
						print(__PRINT_TYPE__, "##COLOR##3##", params.proxy, params.funcName)
					end
				end
			end


			func(realProxy, successCallback, failedCallback, ...)

			if params.limitCall == true then
				_G.__INVOKING_INTERFACES__[getInterfaceKey(proxy, params.funcName)] = true
			end
		end
	else
		assert(false, string.format("No proxy:%s in session:%s", tostring(proxy), session:getType()))
	end
end

--[[
invoke扩展
t 为字符串时：
  接口名 不带_async后缀的
t 为数组时：
  t[1]  接口名 不带_async后缀的
  t[2]  onSuccess回调，参数为返回值，可为空
  t[3]  onFailed回调，可为空
... 参数

eg:
	-- 获取公会信息
	function M:getGuildInfo(guildId)
		local function onSuccess(info)
			dump(info)
		end
		self:invoke({"getGuildInfo", onSuccess}, guildId) 
	end
]]
function M:invokeEx(t, ...)
	local name, onSuccess, onFailed, limitCall = nil, nil, nil, nil
	if type(t) == "table" then
		name, onSuccess, onFailed, limitCall = unpack(t)
	elseif type(t) == "string" then
		name = t
	end

	assert(name)

	local params = {}
	params.funcName = name.."_async"
	params.hasResponse = true
	params.limitCall = limitCall

	params.onSuccess = function(...)
		if onSuccess then
			onSuccess(...)
		end
	end
	params.onFailed = function(...)
		if onFailed then
			onFailed(...)
		end
	end

	self:invoke(params, ...)
end

-- 获取返回值
function M:__getResponse(proxy, funcName)
	-- 去掉后缀
	local name = string.gsub(funcName, "_async", "")
	local responseName = string.format("AMI_%s_%s__response", proxy, name)
	local response = rawget(Message.Game, responseName)
	if response then
		return response()
	end

	return nil
end

return M
