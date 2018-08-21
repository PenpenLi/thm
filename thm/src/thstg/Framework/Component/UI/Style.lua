module("THSTG.UI", package.seeall)

--常用的AnchorPoint------------------------------------
--居中
POINT_CENTER = cc.p(0.5, 0.5)
--左上
POINT_LEFT_TOP = cc.p(0, 1)
--左中
POINT_LEFT_CENTER = cc.p(0, 0.5)
--左下
POINT_LEFT_BOTTOM = cc.p(0, 0)
--右上
POINT_RIGHT_TOP = cc.p(1, 1)
--右中
POINT_RIGHT_CENTER = cc.p(1, 0.5)
--右下
POINT_RIGHT_BOTTOM = cc.p(1, 0)
--中上
POINT_CENTER_TOP = cc.p(0.5, 1)
--中下
POINT_CENTER_BOTTOM = cc.p(0.5, 0)


-----常用颜色-----------------------
COLOR_WHITE = cc.c4b(0xFF, 0xFF, 0xFF, 0xFF)
COLOR_WHITE_F3 = cc.c4b(0xF3, 0xF5, 0xFF, 0xFF)
COLOR_BLACK = cc.c4b(0, 0, 0, 0xFF)
COLOR_RED = cc.c4b(0xFF, 0, 0, 0xFF)
COLOR_GREEN = cc.c4b(0, 0xFF, 0, 0xFF)
COLOR_GREEN_A4 = cc.c4b(0xA4, 0xDA, 0x84, 0xFF)
COLOR_GREEN_B2 = cc.c4b(0xB2, 0xFF, 0x43, 0xFF)
COLOR_GREEN_A1E086 = cc.c4b(0xA1, 0xe0, 0x86, 0xFF)
COLOR_BLUE = cc.c4b(0, 0, 0xFF, 0xFF)
COLOR_YELLOW = cc.c4b(0xFF, 0xFF, 0, 0xFF)
COLOR_YELLOW_FFF6BD = cc.c4b(0xFF, 0xF6, 0xBD, 0xFF)
COLOR_GRAY_3 = cc.c4b(0x33, 0x33, 0x33, 0xFF)
COLOR_GRAY_6 = cc.c4b(0x66, 0x66, 0x66, 0xFF)
COLOR_GRAY_9 = cc.c4b(0x99, 0x99, 0x99, 0xFF)
COLOR_GRAY_A = cc.c4b(0xAA, 0xAA, 0xAA, 0xFF)
COLOR_GRAY_B = cc.c4b(0xBB, 0xBB, 0xBB, 0xFF)
COLOR_GRAY_C = cc.c4b(0xCC, 0xCC, 0xCC, 0xFF)
COLOR_GRAY_D = cc.c4b(0xDD, 0xDD, 0xDD, 0xFF)
COLOR_GRAY_E = cc.c4b(0xEE, 0xEE, 0xEE, 0xFF)


HTML_COLOR_WHITE = "#FFFFFF"
HTML_COLOR_BLACK = "#000000"
HTML_COLOR_RED = "#FF0000"
HTML_COLOR_GREEN = "#00FF00"
HTML_COLOR_BLUE = "#0000FF"
HTML_COLOR_YELLOW = "#FFFF00"
HTML_COLOR_GRAY_3 = "#333333"
HTML_COLOR_GRAY_6 = "#666666"
HTML_COLOR_GRAY_9 = "#999999"
HTML_COLOR_GRAY_A = "#AAAAAA"
HTML_COLOR_GRAY_B = "#BBBBBB"
HTML_COLOR_GRAY_C = "#CCCCCC"
HTML_COLOR_GRAY_D = "#DDDDDD"
HTML_COLOR_GRAY_E = "#EEEEEE"

----字体相关--------------------------------
FONT_FACE = "Arial" --使用cocos2d默认字体 --ResManager.getResSub(ResType.FONT, FontType.TTF, "default")

FONT_SIZE_SMALLER = 16
FONT_SIZE_SMALL = 18
FONT_SIZE_NORMAL = 20
FONT_SIZE_BIG = 22
FONT_SIZE_BIGGER = 24
FONT_SIZE_BIGGEST = 30


----文本相关--------------------------------

TEXT_HALIGN_LEFT = cc.TEXT_ALIGNMENT_LEFT
TEXT_HALIGN_CENTER = cc.TEXT_ALIGNMENT_CENTER
TEXT_HALIGN_RIGHT = cc.TEXT_ALIGNMENT_RIGHT
TEXT_VALIGN_TOP = cc.VERTICAL_TEXT_ALIGNMENT_TOP
TEXT_VALIGN_CENTER = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
TEXT_VALIGN_BOTTOM = cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM

----按钮相关--------------------------------
BUTTON_WIDTH_SMALL = 96
BUTTON_WIDTH_MIDDLE = 150
BUTTON_WIDTH_BIG = 172
BUTTON_HEIGHT_SMALL = 36
BUTTON_HEIGHT_MIDDLE = 48
BUTTON_HEIGHT_BIG = 60
BUTTON_ADDITIONKERNING = 8
BUTTON_SIZE = cc.size(104, 44)
-------------------------------------------------

--裁剪相关
CLIPPINT_STENCIL = 0
CLIPPINT_SCISSOR = 1

--[[
创建文字样式

@param  font				[string]    字体
@param  size				[number]    字体大小
@param  color				[string]    颜色
@param  halign				[number]	水平对齐方式
@param  valign				[number]    垂直对齐方式
@param  lineHeight			[number]    行高，为false表示默认行高
@param  additionalKerning	[number]    字距，为false表示默认字距
@param  underline			[boolean]	是否有下划线
@param  outline				[number]	描边值
@param  outlineColor		[cc.c4b]	描边颜色，c4b
@param  shadow				[boolean]	是否投影
@param  shadowColor			[cc.c4b]    投影颜色
@param  shadowOffset		[cc.size]   投影偏移量
@param  shadowBlurRadius	[number]    投影模糊系数
]]
function newTextStyle(params)
	params = params or {}

	local format = {}
	--字体[string]
	format.font = params.font or FONT_FACE
	--字号[number]
	format.size = params.size or FONT_SIZE_SMALL
	--颜色[table]
	format.color = params.color or clone(COLOR_WHITE_F3)
	--水平对齐方式[cocos type]
	format.halign = params.halign or TEXT_HALIGN_LEFT
	--垂直对齐方式[cocos type]
	format.valign = params.valign or TEXT_VALIGN_CENTER
	--行间距[boolean, number]，为false时表示默认行距，为数值时表示指定行距
	format.lineHeight = params.lineHeight or false
	--字间距[boolean, number]，为false时表示默认字距，为数值时表示指定字距
	format.additionalKerning = params.additionalKerning or false
	--下划线[boolean]
	format.underline = params.underline or false
	--描边大小[number]，为0时表示不描边
	format.outline = params.outline or 0
	--描边颜色[table]
	format.outlineColor = params.outlineColor or clone(COLOR_BLACK)
	--投影
	format.shadow = params.shadow or false
	format.shadowColor = params.shadowColor or getColorHtml("#121212")
	format.shadowOffset = params.shadowOffset or cc.size(2, -2)
	format.shadowBlurRadius = params.shadowBlurRadius or 20

	function format:clone()
		return clone(self)
	end

	return format
end

--缓存皮肤尺寸
local CACHED_SKIN_SIZE = {
	[""] = { width = 0, height = 0 } -- 默认
}

--获取皮肤尺寸
function getSkinSize(src)
	local skinSize = CACHED_SKIN_SIZE[src]
    if not skinSize then
        
        --FIXME:不知何用,先注释掉
		-- if __ENGINE_VERSION__ >= 50 then
		-- 	-- 去预先记录列表找
		-- 	local size = ResManager:getInstance():getImageSize(src)
		-- 	if size.width > 0 and size.height > 0 then
		-- 		CACHED_SKIN_SIZE[src] = size
		-- 		return size	
		-- 	end
		-- end

		skinSize = {width = 2, height = 2}
		if cc.FileUtils:getInstance():isFileExist(src) then
			local tmpSkin = cc.Director:getInstance():getTextureCache():addImage(src)
			local size = tmpSkin:getContentSize()
			skinSize.width = size.width
			skinSize.height = size.height
			CACHED_SKIN_SIZE[src] = skinSize
		end
	end
	return skinSize
end

--获取资源的原始尺寸
function skin2OrgSize(skin)
	return getSkinSize(skin.src)
end

-- skin = {src="Assets/UI/Button/**.png", scale9Rect={left=25, right=25, top=10, bottom=10},
--返回两个值，第一个为CapInsets，第二个为资源的原始尺寸
function skin2CapInsets(skin)
	local capInsets, skinSize = nil, nil

	if not skin then return nil end

	local gridRect = skin.scale9Rect
	if not gridRect or (gridRect.left <= 0 and gridRect.right <= 0 and gridRect.top <= 0 and gridRect.bottom > 0) then
		return nil
	end

	local skinSize = getSkinSize(skin.src)
	if not skinSize then return nil end
	local rect = cc.rect(gridRect.left, gridRect.top, skinSize.width - gridRect.left - gridRect.right, skinSize.height - gridRect.top - gridRect.bottom)
	return rect, skinSize
end

--将html格式的颜色字符串转换成c3b格式的颜色对象，如：UI.htmlColor2C3b("#FFFFFF") -> {r=255, g=255, b=255}
function htmlColor2C3b(htmlColor)
	local len = #htmlColor
	assert((len == 7 or len == 9) and string.sub(htmlColor, 1, 1) == "#", "htmlColor2C3b format error!"..tostring(htmlColor))

	local r = tonumber("0x"..string.sub(htmlColor, 2, 3))
	local g = tonumber("0x"..string.sub(htmlColor, 4, 5))
	local b = tonumber("0x"..string.sub(htmlColor, 6, 7))

	return cc.c3b(r, g, b)
end

--将html格式的颜色字符串转换成c3b格式的颜色对象，如：UI.htmlColor2C4b("#FFFFFFFF") -> {r=255, g=255, b=255, a=255}
function htmlColor2C4b(htmlColor)
	local len = #htmlColor
	assert((len == 7 or len == 9) and string.sub(htmlColor, 1, 1) == "#", "htmlColor2C4b format error!")

	local r = tonumber("0x"..string.sub(htmlColor, 2, 3))
	local g = tonumber("0x"..string.sub(htmlColor, 4, 5))
	local b = tonumber("0x"..string.sub(htmlColor, 6, 7))
	local a = 0xFF
	if len == 9 then
		a = tonumber("0x"..string.sub(htmlColor, 8, 9))
	end

	return cc.c4b(r, g, b, a)
end

getColorHtml = htmlColor2C3b

function getColorByHex(value)
	local x = tonumber(value)
	local r = bit.rshift(bit.band(x, 0xff0000), 16)
	local g = bit.rshift(bit.band(x, 0x00ff00), 8)
	local b = bit.rshift(bit.band(x, 0x0000ff), 0)
	return cc.c3b(r, g, b)
end


function setHitFactor(btn, len)
	if not btn or btn.setHitFactor == nil then return end

	local HIT_MIN_LEN = 60
	if len then
		HIT_MIN_LEN = len
	end

	local scaleX = 1
	local scaleY = 1
	local size = btn:getContentSize()
	if size and size.width and size.width > 0 and size.width < HIT_MIN_LEN then
		scaleX = HIT_MIN_LEN / size.width
	end
	if size and size.height and size.height > 0 and size.height < HIT_MIN_LEN then
		scaleY = HIT_MIN_LEN / size.height
	end
	btn:setHitFactor(cc.p(scaleX, scaleY))

	-- local drawer = cc.DrawNode:create()
	-- btn:addChild(drawer)
	-- local color =  cc.c4f(1, 0, 0, 1)
	-- local posX, posY = btn:getPosition()
	-- drawer:drawRect(
	-- 	cc.p(0,0),
	-- 	cc.p(HIT_MIN_LEN, HIT_MIN_LEN),
	-- 	color)
	-- drawer:setPosition(size.width/2-HIT_MIN_LEN/2, size.height/2-HIT_MIN_LEN/2)
	-- drawer:setAnchorPoint(cc.p(0.5, 0.5))
end
