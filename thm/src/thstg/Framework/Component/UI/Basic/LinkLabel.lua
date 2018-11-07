module("UI", package.seeall)

LINKLABEL_DEFAULT_STYLE = {
	normal = {
		label = UI.newTextStyle({
			color = UI.COLOR_WHITE,
		}),
	},
	pressed = {
		label = UI.newTextStyle({
			color = UI.COLOR_RED,
		}),
	},
	disabled = {
		label = UI.newTextStyle({
			color = UI.COLOR_GRAY_3,
		}),
	}
}

--[[
创建LinkLabel

params中可用参数：
@param	text		[string]	按钮上的文字
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param	anchorPoint	[cc.p]		锚点(如UI.POINT_CENTER)
@param	tag			[number]	tag标识
@param	enabled		[boolean]	是否可用, 为false时显示为disabled状态
@param	onTouch		[function]	点击回调函数(按钮上执行的各种事件)
@param	onClick		[function]	点击回调函数(在按钮上按下并且松开)
@param	style		[table]		样式，结构如：
								{
									normal = {
										label = {font = "MicrosoftYaHei", size=19, color="#FFFFFF"}, 
										
}, 
									pressed = {
										label = {color = "#00FF00"}, 
										
}, 
									disabled = {
										label = {color = "#999999"}, 
										--默认状态下scale9Rect的四个值都是0，left：左边距，right：右边距，top：上边距，bottom：下边距
										
}
}
@return	返回ccui.Button对象

@example
	function onClick(target, event)
		print("Clicked:", target, event)
	end
	
	local btn = UI.newLinkLabel({
		text = "FullStyle", 
		style = {
			normal = {
				label = {
					font = "MicrosoftYaHei", 
					size = 24, 
					color = "#FFFFFF", 
}, 
}, 
			pressed = {
				label = {color = "#FFFFFF"}, 
				
}, 
			disabled = {
				label = {color = "#999999"}, 
}
}, 
		onClick = onClick
})
]]
function newLinkLabel(params)
	if params then
		assert(type(params) == "table", "[UI] newLinkLabel() invalid params")
	else
		params = {}
	end

	local finalParams = {
		text = "",
		x = 0, y = 0,
		width = 0, height = 0,
		anchorPoint = clone(UI.POINT_CENTER),
		enabled = true,
		style = clone(LINKLABEL_DEFAULT_STYLE),
	}
	TableUtil.mergeA2B(params, finalParams)

	local styleNormal = finalParams.style.normal
	local stylePressed = finalParams.style.pressed
	local styleDisabled = finalParams.style.disabled

	local btn = ccui.Button:create()
	btn:ignoreContentAdaptWithSize(false)

	local nodeLine = cc.DrawNode:create()
	nodeLine:setAnchorPoint(UI.POINT_CENTER_BOTTOM)
	btn:addChild(nodeLine)

	if params.hideLine then
		nodeLine:hide()
	end
	--更新文本样式
	local function updateTextStyle(textStyle)
		-- if finalParams.text ~= "" then
			local color = textStyle.color
			btn:setTitleColor(cc.c3b(color.r, color.g, color.b))
			btn:setTitleFontSize(textStyle.size)
			btn:setTitleFontName(textStyle.font)

			local label = btn:getTitleRenderer()
			local labelSize = label:getContentSize()
			btn:setContentSize(labelSize)

			nodeLine:clear()
			local max = 255
			nodeLine.__scale__ = 1
			nodeLine:drawLine(cc.p(0, 0), cc.p(labelSize.width, 0), cc.c4f(color.r / max, color.g / max, color.b / 255, 1))
			nodeLine:setContentSize(cc.size(labelSize.width, 1))
			nodeLine:setPosition(cc.p(0.5 * labelSize.width, 1))
			nodeLine:setScale(nodeLine.__scale__)

			if label then
				label:updateCommomStyle(textStyle)
				-- local outline = textStyle.outline or -1
				-- local outlineColor = textStyle.outlineColor or  UI.COLOR_BLACK
				-- label:enableOutline(cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a), outline)

				-- if type(textStyle.lineHeight) == "number" then
				-- 	label:setLineHeight(textStyle.lineHeight)
				-- end

				-- if type(textStyle.additionalKerning) == "number" then
				-- 	label:setAdditionalKerning(textStyle.additionalKerning)
				-- end
			end
		-- end
	end

	local __setEnabled = btn.setEnabled
	function btn:setEnabled(value)
		if btn:isEnabled() ~= value then
			__setEnabled(self, value)
			self:setBright(value)

			local textStyle = value and styleNormal.label or styleDisabled.label
			updateTextStyle(textStyle)
		end
	end
	btn:setTouchEnabled(true)
	btn:setPressedActionEnabled(true)
	btn:setAnchorPoint(finalParams.anchorPoint)
	btn:setPosition(finalParams.x, finalParams.y)

	if finalParams.text ~= "" then
		btn:setTitleText(finalParams.text)
		updateTextStyle(styleNormal.label)
	end

	if finalParams.width > 0 or finalParams.height > 0 then
		local texSize = btn:getVirtualRendererSize()
		if finalParams.width <= 0 then
			finalParams.width = texSize.width
		end
		if finalParams.height <= 0 then
			finalParams.height = texSize.height
		end
		btn:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	if type(finalParams.zoomScale) == "number" then
		btn:setZoomScale(finalParams.zoomScale)
	end

	local info
	if __PRINT_TRACK__ then
		info = getTraceback()
	end
	local function onTouch(sender, eventType)
		if type(params.onTouch) == "function" then
			params.onTouch(sender, eventType)
		end

		if eventType == ccui.TouchEventType.began then
			updateTextStyle(stylePressed.label)

		elseif eventType == ccui.TouchEventType.moved then

		elseif eventType == ccui.TouchEventType.ended then
			if type(params.onClick) == "function" then
				params.onClick(sender, "click")
				printStack(params.onClick)
				if __PRINT_TRACK__ and info then
					print(__PRINT_TYPE__, info)
				end
			end
			updateTextStyle(styleNormal.label)
		elseif eventType == ccui.TouchEventType.canceled then
			updateTextStyle(styleNormal.label)
		end
		if btn:isHighlighted() then
			local zoomScale = btn:getZoomScale()
			nodeLine:setScale(zoomScale + nodeLine.__scale__)
		else
			nodeLine:setScale(nodeLine.__scale__)
		end
	end
	btn:addTouchEventListener(onTouch)
	btn:setEnabled(finalParams.enabled)

	function btn:onClick(func)
		params.onClick = func
	end
	
	local setContentSize = btn.setContentSize
	function btn:setContentSize(size)
		local label = btn:getTitleRenderer()
		if not tolua.isnull(label) then
			local labelSize = label:getContentSize()
			setContentSize(btn, labelSize)
		end
	end
	function btn:setStyle( styleTb )
		local default = clone(LINKLABEL_DEFAULT_STYLE)
		TableUtil.mergeA2B(styleTb, default)
		styleNormal = default.normal
	 	stylePressed = default.pressed
		styleDisabled = default.disabled
		updateTextStyle(styleNormal.label)
	end
	function btn:setText(content)
		btn:setTitleText(content)
		updateTextStyle(styleNormal.label)
	end
	return btn
end

function  newMultColorLinkLabel( params )
	local multColorLabel
	params.onTouch = function ( sender, eventType )
		if not tolua.isnull(multColorLabel) then
			if sender:isHighlighted() then
				local zoomScale = sender:getZoomScale()
				multColorLabel:setScale(zoomScale + 1)
			else
				multColorLabel:setScale(1)
			end
		end 
	end
	if not params.hideLine then
		params.underline = true
	end 
	params.hideLine = true
	local link = newLinkLabel(params)
	params.anchorPoint = ccp(0.5,0.5)

	multColorLabel = UI.newTintoLabel(params)
	
	local  size = multColorLabel:getContentSize()
	multColorLabel:setPosition(size.width/2,size.height/2)
	link:addChild(multColorLabel)
	local label = link:getTitleRenderer()
	label:setVisible(false)
	return link
end