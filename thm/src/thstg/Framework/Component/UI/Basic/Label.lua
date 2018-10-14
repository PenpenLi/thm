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
		local defaultStyle = THSTG.UI.newTextStyle()
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
	style = THSTG.UI.newTextStyle()
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
	THSTG.TableUtil.mergeA2B(params, finalParams)

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
	finalParams.style.font = "Arial"
	THSTG.TableUtil.mergeA2B(params, finalParams)

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

	function label:updateStyle(style)
		if type(style.font) == "string" then
			self:setFntFile(style.font)
		end
		
		if type(style.additionalKerning) == "number" then
			local renderText = tolua.cast(self:getVirtualRenderer(), "cc.Label")
			if renderText then
				renderText:setAdditionalKerning(style.additionalKerning)
			end
		end
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
	-- finalParams.style.font = ResManager.getResSub(ResType.FONT, FontType.CHAR_MAP, "tuffy")
	THSTG.TableUtil.mergeA2B(params, finalParams)

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

--[[
-----------------------------
-- 创建一个使用charmap格式的png文件的文本
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)，注：style下的（描边、字号）相关属性无效，color无透明度
	--@@param  font				[table]		字体
		-- @@@param	src				[string]	关联的字符集的图片。
		-- @@@param	itemWidth		[number]	每一字符图片占用的宽度px。
		-- @@@param	itemHeight		[number]	每个字符图片占用的高度px
		-- @@@param	startChar		[number]	图片开始的字符的ASCII码。
]]
function newAtlasLabel(params)
	assert(type(params) == "table", "[UI] newLabel() invalid params")

	local finalParams = clone(LABEL_DEFAULT_PARAMS)
	-- finalParams.style.font = ResManager.getResSub(ResType.FONT, FontType.CHAR_MAP, "tuffy")
	THSTG.TableUtil.mergeA2B(params, finalParams)

	local startCharMap = ((type(finalParams.style.font.startChar) == "string") and {string.byte(finalParams.style.font.startChar)} or {finalParams.style.font.startChar or 48})[1]
	local label = cc.LabelAtlas:_create(
		finalParams.text, 
		finalParams.style.font.src,
		finalParams.style.font.itemWidth, 
		finalParams.style.font.itemHeight, 
		startCharMap)

	local color = finalParams.style.color
	label:setColor(cc.c3b(color.r, color.g, color.b))

	if finalParams.width > 0 or finalParams.height > 0 then
		local oriSize = label:getContentSize()
		local dWidthPerc = (finalParams.width or oriSize.width) / oriSize.width
		local dHeightPerc = (finalParams.height or oriSize.height) / oriSize.height
		label:setScale(dWidthPerc,dHeightPerc)
	end

	commonInit(label, finalParams)

	return label

end


local function getTintoGlProgram(topColor,bottomColor)
	topColor = topColor or  "#000000"
	bottomColor = bottomColor or "#ffffff"
	local shaderKey = topColor..bottomColor
	local glProgramCache = cc.GLProgramCache:getInstance()
	local glProgram = glProgramCache:getGLProgram(shaderKey)

	if not glProgram then
		local vertex = [[
			attribute vec4 a_position;
			attribute vec2 a_texCoord;
			attribute vec4 a_color;
			#ifdef GL_ES
			varying lowp vec4 v_fragmentColor;
			varying mediump vec2 v_texCoord;
			#else
			varying vec4 v_fragmentColor;
			varying vec2 v_texCoord;
			#endif
						
			uniform vec4 topColor;
			uniform vec4 bottomColor;

			void main()
			{
				gl_Position = CC_PMatrix * a_position;
				v_texCoord = a_texCoord;

				vec3 tintColor = topColor.xyz*v_texCoord.y + bottomColor.xyz*(1.0-v_texCoord.y);
				v_fragmentColor = vec4(tintColor.xyz,0);
			}
		]]
		local fragment= [[
			#ifdef GL_ES
			precision mediump float;
			#endif
			varying vec4 v_fragmentColor;
			varying vec2 v_texCoord;
			
			void main(void)
			{
				vec4 c = texture2D(CC_Texture0, v_texCoord);
				gl_FragColor = vec4(v_fragmentColor.xyz,c.a);
			}
		]]
		glProgram = cc.GLProgram:createWithByteArrays(vertex , fragment)
		if not glProgram then return end
		local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
		local topColorTb = THSTG.UI.getColorHtml(topColor)
		local bottomColorTb = THSTG.UI.getColorHtml(bottomColor)
		local topColorVec4 = cc.vec4(topColorTb.r/255,topColorTb.g/255,topColorTb.b/255,0)
		local bottomColorVec4 = cc.vec4(bottomColorTb.r/255,bottomColorTb.g/255,bottomColorTb.b/255,0)
		glProgramState:setUniformVec4("topColor",topColorVec4)
		glProgramState:setUniformVec4("bottomColor",bottomColorVec4)
		glProgramCache:addGLProgram(glProgram, shaderKey)
	end
	return glProgram
end

--[[
-----------------------------
-- 创建一个拥有渐变色的Label
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	topColor		[cc.p]		顶部颜色
-- @param	bottomColor		[cc.p]		底部颜色
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)，注：style下的（描边、字号）相关属性无效，color无透明度
]]
function newTintoLabel(params)	
	local node = THSTG.UI.newWidget({
		x = params.x or 0,
		y = params.y or 0
	})
	local anchorPoint = params.anchorPoint or THSTG.UI.POINT_LEFT_BOTTOM
	node:setAnchorPoint(cc.p(anchorPoint.x,anchorPoint.y))
	if params.style then
		params.style.outline = 0
	end 

	local label = THSTG.UI.newLabel({
		text = params.text or "",
		style = params.style
	})
	label:retain()
	local labelSize = label:getContentSize()
	node:setContentSize(labelSize)
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end 
	local sprite = false
	local scheduler = false
	local function addSprite()
		local renderTexture = cc.RenderTexture:create(labelSize.width,labelSize.height)
		renderTexture:beginWithClear(0,0,0,0)
		if params.underline then
			local nodeLine = cc.DrawNode:create()
			nodeLine:setAnchorPoint(POINT_CENTER_BOTTOM)
			nodeLine:drawLine(cc.p(0, 0), cc.p(labelSize.width, 0), cc.c4f(1,1,1,1))
			nodeLine:setContentSize(cc.size(labelSize.width, 1))
			nodeLine:setPosition(cc.p(labelSize.width/2, 1))
			label:addChild(nodeLine)
		end
		label:visit()
		renderTexture:endToLua()
		sprite = THSTG.UI.newSprite({
			x = labelSize.width/2,
			y = labelSize.height/2
		})
		sprite:setSpriteFrame(renderTexture:getSprite():getSpriteFrame())
		sprite:setFlippedY(true)
		local glProgram = getTintoGlProgram(params.topColor,params.bottomColor)
		sprite:setGLProgram(glProgram)		
		node:addChild(sprite)
	end
	node:onNodeEvent("enter",function ()
		if not sprite and not scheduler then
			addSprite()-- scheduler = THSTG.Scheduler.scheduleNextFrame(addSprite)
		end
	end)
	node:onNodeEvent("exit",function ()
		if scheduler then
			-- THSTG.Scheduler.unschedule(scheduler)
			scheduler = false
		end
		if not tolua.isnull(label) then
			label:release()
		end
	end)
	return node
end
