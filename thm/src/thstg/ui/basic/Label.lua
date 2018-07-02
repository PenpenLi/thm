module("THSTG.UI", package.seeall)

--扩展cc.Label
local ccLabel = cc.Label
function ccLabel:updateCommomStyle(style)
	if style.halign then
		self:setHorizontalAlignment(style.halign)
	end
	if style.valign then
		self:setVerticalAlignment(style.valign)
	end
	if style.outline then
		if style.outline > 0 then
			local outlineColor = style.outlineColor or COLOR_BLACK
			self:enableOutline(cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a), style.outline)
		end
	end
	if style.color then
		self:setTextColor(cc.c4b(style.color.r, style.color.g, style.color.b, style.color.a))
	end
	if type(style.lineHeight) == "number" then
		self:setLineHeight(style.lineHeight)
	end
	if type(style.additionalKerning) == "number" then
		self:setAdditionalKerning(style.additionalKerning)
	end
	if style.shadow then
		local defaultStyle = newTextStyle()
		self:enableShadow(style.shadowColor or defaultStyle.shadowColor, style.shadowOffset or  defaultStyle.shadowOffset, style.shadowBlurRadius or defaultStyle.shadowBlurRadius)
	end
end

LABEL_DEFAULT_PARAMS = {
	text = "",
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = POINT_LEFT_BOTTOM,
	style = newTextStyle()
}

--几种不同类型Label的通用初始化部分
local function commonInit(label, params)
	label:setAnchorPoint(params.anchorPoint)
	label:setPosition(params.x, params.y)

	if type(params.style.lineHeight) == "number" then
		if label.setLineHeight then
			label:setLineHeight(params.style.lineHeight)
		else
			local renderText = tolua.cast(label:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:setLineHeight(params.style.lineHeight)
			end
		end

	end

	if type(params.style.additionalKerning) == "number" then
		if label.setAdditionalKerning then
			label:setAdditionalKerning(params.style.additionalKerning)
		else
			local renderText = tolua.cast(label:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:setAdditionalKerning(params.style.additionalKerning)
			end
		end

	end

	if params.style.shadow then
		if label.enableShadow then
			label:enableShadow(params.style.shadowColor, params.style.shadowOffset, params.style.shadowBlurRadius)
		else
			local renderText = tolua.cast(label:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:enableShadow(params.style.shadowColor, params.style.shadowOffset, params.style.shadowBlurRadius)
			end
		end
	end

	--设置文本
	function label:getText() return self:getString() end
	function label:setText(value)
		self:setString(tostring(value))
	end
end

-----------------------------
-- 创建一个使用ttf字体文件的文本
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)
function newLabel(params)
	params = params or {}
	assert(type(params) == "table", "[UI] newLabel() invalid params")

	local finalParams = clone(LABEL_DEFAULT_PARAMS)
	THSTG.UTILS.TableUtil.mergeA2B(params, finalParams)

	-- local label = cc.Label:createWithTTF(
	-- 	finalParams.text,
	-- 	finalParams.style.font,
	-- 	finalParams.style.size,
	-- 	cc.size(finalParams.width, finalParams.height),
	-- 	finalParams.style.halign,
	-- 	finalParams.style.valign
	-- )
	local label = ccui.Text:create(
		finalParams.text,
		finalParams.style.font,
		finalParams.style.size
	)
	label:setTextHorizontalAlignment(finalParams.style.halign)
	label:setTextVerticalAlignment(finalParams.style.valign)
	local color = finalParams.style.color
	label:setTextColor(cc.c4b(color.r, color.g, color.b, color.a))

	if finalParams.style.outline > 0 then
		local outlineColor = finalParams.style.outlineColor
		label:enableOutline(cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a), finalParams.style.outline)
	end

	if params.width then
		local renderText = label:getVirtualRenderer()
		renderText:setLineBreakWithoutSpace(true)
		renderText:setMaxLineWidth(params.width)
	end
	commonInit(label, finalParams)

	function label:updateStyle(style)
		if style.font then
			self:setFontName(style.font)
		end
		if style.size then
			self:setFontSize(style.size)
		end
		if style.halign then
			self:setTextHorizontalAlignment(style.halign)
		end
		if style.valign then
			self:setTextVerticalAlignment(style.valign)
		end
		if style.outline then
			if style.outline > 0 then
				local outlineColor = style.outlineColor or finalParams.style.outlineColor
				self:enableOutline(cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a), style.outline)
			end
		end
		if style.color then
			self:setTextColor(cc.c4b(style.color.r, style.color.g, style.color.b, style.color.a))
		end
		if type(style.lineHeight) == "number" then
			local renderText = tolua.cast(self:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:setLineHeight(style.lineHeight)
			end
		end
		if type(style.additionalKerning) == "number" then
			local renderText = tolua.cast(self:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:setAdditionalKerning(style.additionalKerning)
			end
		end
		if style.shadow then
			local renderText = tolua.cast(self:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:enableShadow(style.shadowColor or finalParams.style.shadowColor, style.shadowOffset or  finalParams.style.shadowOffset, style.shadowBlurRadius or finalParams.style.shadowBlurRadius)
			end
		end
	end

	function label:getContentSize()
		return label:getVirtualRendererSize()
	end

	function label:setColor(value)
		if type(value) == "string" then
			value = getColorHtml(value)
		end
		label:setTextColor(value)
	end

	function label:onClick(func, swallow)
		local function onTouch(sender, eventType)
			if eventType == ccui.TouchEventType.began then
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.ended then
				func(sender)
				printStack(func)
			end
		end
		label:setTouchEnabled(true)
		if swallow == nil then
			swallow = true
		end
		label:setSwallowTouches(swallow)
		label:addTouchEventListener(onTouch)
	end

	if __PRINT_TRACK__ then
		local info = getTraceback()
		if params.onClick then
			label:onClick(params.onClick)
			printStack(params.onClick)
		else
			label:onClick(function ()
				print(__PRINT_TYPE__, info)
				if params.mornFile then
					print(__PRINT_TYPE__, "mornFile - ", params.mornFile)
				end
				if params.mornName then
					print(__PRINT_TYPE__, "mornName - ", params.mornName)
				end
			end, false)
		end
	else
		if params.onClick then
			label:onClick(params.onClick)
			printStack(params.onClick)
		end
	end

	return label
end

-----------------------------
-- 创建一个使用BMFont字体文件的文本
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)，注：style下的（描边、字号、颜色）相关属性无效
function newBMFontLabel(params)
	assert(type(params) == "table", "[UI] newLabel() invalid params")

	local finalParams = clone(LABEL_DEFAULT_PARAMS)
	finalParams.style.font = ResManager.getResSub(ResType.FONT, FontType.FNT, "arial")
	TableUtil.mergeA2B(params, finalParams)

	-- local label = cc.Label:createWithBMFont(
	-- 	finalParams.style.font,
	-- 	finalParams.text,
	-- 	finalParams.style.halign,
	-- 	finalParams.width
	-- )
	local label = ccui.TextBMFont:create(finalParams.text, finalParams.style.font)
	commonInit(label, finalParams)

	if params.width then
		local renderText = label:getVirtualRenderer()
		renderText:setLineBreakWithoutSpace(true)
		renderText:setMaxLineWidth(params.width)
	end

	-- function label:getContentSize()
	-- 	return label:getVirtualRendererSize()
	-- end
	return label
end

-----------------------------
-- 创建一个使用charmap格式的plist字体文件的文本
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)，注：style下的（描边、字号）相关属性无效，color无透明度
function newCharMapLabel(params)
	assert(type(params) == "table", "[UI] newLabel() invalid params")

	local finalParams = clone(LABEL_DEFAULT_PARAMS)
	finalParams.style.font = ResManager.getResSub(ResType.FONT, FontType.CHAR_MAP, "tuffy")
	TableUtil.mergeA2B(params, finalParams)

	print(5, "finalParams.style.font", finalParams.style.font)

	local label = cc.Label:createWithCharMap(finalParams.style.font)
	label:setString(finalParams.text)

	local color = finalParams.style.color
	label:setColor(cc.c3b(color.r, color.g, color.b))

	if finalParams.width > 0 or finalParams.height > 0 then
		label:setDimensions(finalParams.width, finalParams.height)
	end

	commonInit(label, finalParams)

	return label
end
