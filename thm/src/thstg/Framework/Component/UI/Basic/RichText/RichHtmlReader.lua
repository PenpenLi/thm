module("UI", package.seeall)

local KIND_FROM_POS_P = "<%s*([_%a][_%w]*)()"
local FONT_TO_POS_P = "()%s*>"
local TO_POS_P = "()/%s*>"
local SPACE_2_COMMA_P = "([\'\"}%d])(%s+)([_%a][_%w]*)"

--传入参数中是否为结束标签
local function containsEndFlag(str)
	return string.find(str, "<%s*/") or string.find(str, "/%s*>")
end

local function createElement(content, htmlHead)
	-- print(1, "~~~~111~~ content:", content and content or type(content), "htmlHead:", htmlHead and htmlHead or type(htmlHead))
	local params, kind = nil, "font"
	if htmlHead then
		local tmpKind, fromPos = string.match(htmlHead, KIND_FROM_POS_P)
		kind = tmpKind

		local toPos = string.match(htmlHead, (kind == "font" or kind == "bmfont") and FONT_TO_POS_P or TO_POS_P)
		local subStr = string.sub(htmlHead, fromPos, toPos-1)
		subStr = string.format("return {%s}", string.gsub(subStr, SPACE_2_COMMA_P, "%1, %3"))
		params = assert(loadstring(subStr))()
	else
		params = {}
	end

	if kind == "font" or kind == "bmfont" then
		params.text = content
	end

	return {kind = string.lower(kind), params = params}
end

--解析html文本成一个个的RichText元素
function decodeHtmlText(htmlText, defaultTextStyle)
	--元素列表
	local elements = {}

	local headPos = 1
	local isWaitingTail = false
	local beginPos, toPos = 0, 0
	local headStr = nil

	local function pushData2Elements(content, htmlHead)
		local params = createElement(content, htmlHead)
		table.insert(elements, params)
	end

	for from, text, to in string.gmatch(htmlText, "()(%b<>)()") do
		-- print(1, "---111---", text, from, to)
		if not isWaitingTail and from > headPos then
			pushData2Elements(string.sub(htmlText, headPos, from-1))
		end

		if containsEndFlag(text) then
			if isWaitingTail then
				pushData2Elements(string.sub(htmlText, headPos, from-1), headStr)
			else
				pushData2Elements(nil, text)
			end
			isWaitingTail = false
		else
			if isWaitingTail and headStr then
				pushData2Elements(headStr)
				printf("RichHtmlReader.decodeHtmlText, html format error! Auto remove tag:\"%s\"", text)
			end
			headStr = text
			isWaitingTail = true
		end
		headPos = to
	end

	local htmlTextLen = #htmlText
	if headPos <= htmlTextLen then
		pushData2Elements(string.sub(htmlText, headPos))
	end

	-- printTable(1, elements)

	return elements
end
