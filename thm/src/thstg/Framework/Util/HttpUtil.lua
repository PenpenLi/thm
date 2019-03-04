module("HttpUtil", package.seeall)

local URLDecode = string.urldecode

--正在请求中的url
local _requestingURLs = {}

local private = {}

--将t表的k、v全部urldecode到新表返回
function private.urldecodeTable(t)
	local tmpT = {}

	for k, v in pairs(t) do
		local typeK, typeV = type(k), type(v)
		local finalK, finalV = k, v

		--直接认为key不存在table，出现了的话就找php麻烦
		if typeK == "string" then
			finalK = URLDecode(k) or k
		end

		if typeV == "table" then
			finalV = private.urldecodeTable(v)
		elseif typeV == "string" then
			finalV = URLDecode(v) or v
		end

		tmpT[finalK] = finalV
	end

	return tmpT
end

function private.showTipMsg(msg, isShow)
	if msg and msg ~= "" then
		if isShow == nil then isShow = true end
		
		if isShow and MsgManager then
			MsgManager.showRollTipsMsg(msg)
		end

		if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
			or CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
		then
			LuaLogE("~~~~~HttpUtil~~~~~~"..tostring(msg))
		end
	end
end

function private.onHttpResponse(dict, onSuccess, onFailed, url, showTips, decodeResult)
	--http返回
	_requestingURLs[url] = nil
	if dict.status ~= 200 then
		private.showTipMsg(string.format("HTTP response error status=%s", dict.status), showTips)
		if onFailed then
			onFailed({code = -1, reason = string.format("status = %s", dict.status), status = dict.status})
		end
		return
	end
	
	if decodeResult then
		local jsContent = json.decode(dict.data)
		if type(jsContent) == "table" then
			jsContent = private.urldecodeTable(jsContent)
			local code = tonumber(jsContent.code)
			if code == 1000 then
				if type(jsContent.data) == "string" and jsContent.data ~= "" then
					private.showTipMsg(jsContent.data, showTips)
				end
				if onSuccess then
					onSuccess(jsContent.data)
				end
			else
				local reason = jsContent.content
				if type(reason) == "string" and reason ~= "" then
					private.showTipMsg(reason, showTips)
				end

				if onFailed then
					onFailed({code = code, reason = reason, data = jsContent.data})
				end
			end
		else
			private.showTipMsg("HTTP response error! data = -1", showTips)
			if onFailed then
				onFailed({code = -1, reason = "data = -1"})
			end
		end
	else
		if onSuccess then
			onSuccess(dict.data)
		end
	end
end

function private.getFormatedURLData(params, key, signWord)
	if signWord == nil then 
		signWord = "sign" 
	end

	local tmpT = {}
	for k, v in pairs(params) do
		table.insert(tmpT, tostring(k).."="..string.urlencode(v))
	end
	if #tmpT > 0 then
		table.sort(tmpT)
		local paramsStr = table.concat(tmpT, "&")
		local md5str = paramsStr..key
		local sign = string.format("&%s=%s", signWord, string.lower(THSTG.MD5.string(md5str)))
		return paramsStr..sign
	else
		return ""
	end
end

function private.sendGet(params)
	local url = string.format("%s%s?%s", params.ip, params.action, private.getFormatedURLData(params.params, params.key))

	local function scriptHandler(dict)
		if params.onFinish then
			params.onFinish(dict)
		end
		private.onHttpResponse(dict, params.onSuccess, params.onFailed, url, params.showTips, params.decodeResult)
	end

	-- LuaLogE("~~~~~sendGet~~~~~url:" .. url)
	if __ENGINE_VERSION__ >= 24 then
		FRHttpClient:sendGet(url, scriptHandler, params.isCompress, params.timeoutForConnect, params.timeoutForRead, params.isImmediate)
	elseif __ENGINE_VERSION__ >= 21 then
		FRHttpClient:sendGet(url, scriptHandler, params.isCompress, params.timeoutForConnect, params.timeoutForRead)
	else
		FRHttpClient:sendGet(url, scriptHandler, params.isCompress, params.timeoutForRead)
	end

end

function private.sendPost(params)
	local url = string.format("%s%s", params.ip, params.action)

	if _requestingURLs[url] then
		local errorStr = string.format("The url is requesting:%s", url)
		private.showTipMsg(errorStr, false)
		if params.onFailed then
			params.onFailed({code = -2, reason = errorStr})
		end
		return
	end

	local data = private.getFormatedURLData(params.params, params.key)
	local failedTimes = 0
	local scriptHandler = nil

	local function doSendPost()
		_requestingURLs[url] = true
		-- LuaLogE(string.format("~~~~~sendPost~~~~~\nurl:%s\ndata:%s", url, tostring(data)))
		if __ENGINE_VERSION__ >= 24 then
			FRHttpClient:sendPost(url, data, scriptHandler, params.isCompress, params.timeoutForConnect, params.timeoutForRead, params.isImmediate)
		elseif __ENGINE_VERSION__ >= 21 then
			FRHttpClient:sendPost(url, data, scriptHandler, params.isCompress, params.timeoutForConnect, params.timeoutForRead)
		else
			FRHttpClient:sendPost(url, data, scriptHandler, params.isCompress, params.timeoutForRead)
		end
	end

	scriptHandler = function(dict)
		local function onFailed(data)
			failedTimes = failedTimes + 1
			if failedTimes >= params.retryTimes then
				if params.onFailed then
					params.onFailed(data)
				end
			else
				-- print(5, "~~~~~request failed~~~~~~~", url, failedTimes)
				if params.retryDelay <= 0 then
					doSendPost()
				else
					Scheduler.scheduleOnce(params.retryDelay, doSendPost)
				end
			end
		end
		private.onHttpResponse(dict, params.onSuccess, onFailed, url, params.showTips, params.decodeResult)
	end

	doSendPost()
end

------以下为公共接口-------------------------

-- 常规http请求，该接口不适合用于下载文件
-- ip					#string		地址，参考AgentConfig.centerURL
-- action				#string		要执行的操作，一般使用HttpActionType枚举中的值
-- key					#string		加密用key，一般使用AgentConfig.logKey
-- params				#table		执行该条http请求的参数
-- isGet				#boolean	是否使用get，默认使用post
-- timeoutForConnect	#number		连接超时时间(s)，默认值60s
-- timeoutForRead		#number		下载超时时间(s)，默认值60s
-- showTips				#boolean	是否显示异常飘字，默认值为false
-- isCompress			#boolean	返回数据是否经过了压缩处理，默认值为true
-- decodeResult			#boolean	是否使用decode处理返回的数据，默认值为true
-- retryTimes			#boolean	请求失败时尝试的次数，默认为1次
-- retryDelay			#number		请求失败再次尝试的延时(s)，为0或者nil时立马再次请求
-- isImmediate			#boolean    是否独立线程执行请求，默认为false
-- onSuccess			#function	请求成功的回调，如：local function onSuccess(data) end
-- onFailed				#function	请求失败的回调，如：local function onFailed(data) end
function send(params)
	params = params or {}
	assert(type(params.ip) == "string", type(params.ip).." ip must be a string")
	assert(type(params.action) == "string", type(params.action).." action must be a string")
	assert(type(params.key) == "string", type(params.key).." key must be a string")
	assert(type(params.params) == "table", type(params.params).." params must be a table")

	if not params.timeoutForConnect then
		params.timeoutForConnect = 30
	end

	if not params.timeoutForRead then
		params.timeoutForRead = 60
	end

	if not params.retryTimes then
		params.retryTimes = 1
	end

	if not params.retryDelay then
		params.retryDelay = 0
	end

	if params.isImmediate == nil then
		params.isImmediate = false
	end

	if params.isCompress == nil then
		params.isCompress = true
	end

	if params.decodeResult == nil then
		params.decodeResult = true
	end

	if not params.isGet then
		private.sendPost(params)
	else
		private.sendGet(params)
	end
end

--传入参数并下载文件
function sendGetFile(params)
	params = params or {}
	assert(type(params.onFinish) == "function", type(params.onFinish).." onFinish must be a function")
	assert(type(params.url) == "string", type(params.url).." url must be a string")
	assert(type(params.fileName) == "string", type(params.fileName).." fileName must be a string")
	assert(type(params.filePath) == "string", type(params.filePath).." filePath must be a string")

	if not params.onProgress then
		params.onProgress = 0
	end

	if not params.timeoutForConnect then
		params.timeoutForConnect = 30
	end

	if not params.timeoutForRead then
		params.timeoutForRead = 60
	end

	if __ENGINE_VERSION__ >= 21 then
		FRHttpClient:toGetFile(params.onFinish, params.onProgress, params.url, params.fileName, params.filePath, params.timeoutForConnect, params.timeoutForRead)
	else
		FRHttpClient:toGetFile(params.onFinish, params.onProgress, params.url, params.fileName, params.timeoutForRead, params.filePath)
	end
end

--传入参数并上传文件
function sendPostFile(params)
	params = params or {}
	assert(type(params.onFinish) == "function", type(params.onFinish).." onFinish must be a function")
	assert(type(params.url) == "string", type(params.url).." url must be a string")
	assert(type(params.fileFullPath) == "string", type(params.fileFullPath).." fileFullPath must be a string")

	if not params.onProgress then
		params.onProgress = 0
	end

	if not params.timeoutForConnect then
		params.timeoutForConnect = 30
	end

	if not params.timeoutForRead then
		params.timeoutForRead = 60
	end

	if params.isCompress == nil then
		params.isCompress = true
	end

	if __ENGINE_VERSION__ >= 21 then
		FRHttpClient:toPostFile(params.onFinish, params.onProgress, params.url, params.fileFullPath, params.isCompress, params.timeoutForConnect, params.timeoutForRead)
	else
		FRHttpClient:toPostFile(params.onFinish, params.onProgress, params.url, params.fileFullPath, params.timeoutForRead, params.isCompress)
	end
end

--格式化URL数据
function getFormatedURLData(params, key, signWord)
	return private.getFormatedURLData(params, key, signWord)
end
