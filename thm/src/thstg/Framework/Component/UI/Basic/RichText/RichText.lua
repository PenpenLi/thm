module("THSTG.UI", package.seeall)

require "thstg.Framework.Component.UI.Basic.RichText.RichHtmlReader"

local s_style = newTextStyle()
s_style.verticalSpace = 0

RICH_TEXT_DEFAULT_PARAMS = {
	text = "",
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = POINT_LEFT_TOP,
	updateSizeNow = true,
	style = s_style
}

--解析器可用的标签
local enableTags = {
	"font", --文本
	"img", --图片
	"btn", --按钮
	"br", --换行
}

--[[
创建一个文本

params下的参数
@param	text			[string]	显示的文字
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	updateSizeNow	[boolean]	文字变化立即更新大小
@param	anchorPoint		[cc.p]	锚点
@param	onTap			[function]	点击回调
@param	style			[table]		文本样式，暂时只支持文本描边样式
]]
function newRichText(params)
	if params then
		assert(type(params) == "table", "[UI] newRichText() invalid params")
	else
		params = {}
	end

	local finalParams = clone(RICH_TEXT_DEFAULT_PARAMS)
	THSTG.TableUtil.mergeA2B(params, finalParams)
	-- dump(finalParams)
	local text = ""

	local richText = ccui.RichText:create()
	richText:setAnchorPoint(finalParams.anchorPoint)
	richText:setPosition(finalParams.x, finalParams.y)
	if finalParams.width > 0 then
		richText:setContentSize(cc.size(finalParams.width, finalParams.height))
		richText:ignoreContentAdaptWithSize(false)
	end
	richText:setVerticalSpace(finalParams.style.verticalSpace)
	richText:setHorizontalAlignment(finalParams.style.halign)

	local preHtmlText = nil
	--重新构建文本内容
	function richText:getText() return text end
	function richText:setText(htmlText)
		if preHtmlText == htmlText then
			--print(168, "same")
			return
		end
		text = ""
		preHtmlText = nil
		self:removeAllElements()
		self:appendText(htmlText)
	end
	--添加文本到后面，如果只是往文本后面增加内容，请使用该接口
	function richText:appendText(htmlText)
		if not htmlText then return end
		preHtmlText = preHtmlText or ""
		preHtmlText = preHtmlText..tostring(htmlText)
		htmlText = string.gsub(htmlText, "\n", "<br/>")
		-- print(1, "~~~~~~~~", htmlText)
		text = text .. htmlText
		local elements = decodeHtmlText(htmlText)
		for k, v in ipairs(elements) do
			if v.kind == "font" then
				local style = clone(finalParams.style)
				if v.params.style then
					if type(v.params.style.color) == "string" then
						v.params.style.color = htmlColor2C3b(v.params.style.color)
					end
					if type(v.params.style.outlineColor) == "string" then
						v.params.style.outlineColor = htmlColor2C4b(v.params.style.outlineColor)
					end
				end
				THSTG.TableUtil.mergeA2B(v.params.style, style)
				local lb = ccui.RichElementText:create(0, cc.c3b(style.color.r, style.color.g, style.color.b), 255, v.params.text, style.font, style.size)
				if style.outline > 0 then
					local outlineColor = style.outlineColor
					lb:enableOutline(cc.c4b(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a), style.outline)
				end

				if finalParams.style.shadow then
					lb:enableShadow(finalParams.style.shadowColor, finalParams.style.shadowOffset)
				end	

				self:pushBackElement(lb)
			elseif v.kind == "btn" then
				local btn = newButton(v.params)
				local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, btn)
				self:pushBackElement(element)
			elseif v.kind == "img" then
				local sp = cc.Sprite:create(v.params.src)
				local scaleX = 1
				local scaleY = 1
				if v.params.scale then
					scaleX = v.params.scale
					scaleY = v.params.scale
				else
					if v.params.width and v.params.width > 0 then
						scaleX = v.params.width / sp:getContentSize().width
					end
					if v.params.height and v.params.height > 0 then
						scaleY = v.params.height / sp:getContentSize().height
					end
				end
				if __ENGINE_VERSION__ < 50 then
					sp:setScaleX(scaleX)
					sp:setScaleY(scaleY)
				end
				sp:setContentSize(cc.size(sp:getContentSize().width * scaleX, sp:getContentSize().height * scaleY))

				if v.params.discolored then
					sp:setDiscolored(v.params.discolored)
				end
				if v.params.rotation then
					sp:setRotation(v.params.rotation)
				end

				local size = sp:getContentSize()
				local itemNode = newNode({
					width = size.width,
					height = size.height,
				})
				local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, itemNode)
				self:pushBackElement(element)
				local x = size.width/2 + (v.params.x or 0)
				local y = size.height/2 + (v.params.y or 0)
				if __ENGINE_VERSION__ >= 50 then
					x = size.width/2 + (v.params.x or 0) * scaleX
					y = size.height/2 + (v.params.y or 0) * scaleY
				end

				sp:setPosition(ccp(x,y))
				itemNode:addChild(sp)
			elseif v.kind == "scale9" then

				-- local sp = newScale9Sprite({
				-- 	width = v.width,
				-- 	height = v.height,
				-- 	style = {
				-- 		src = v.src,
				-- 		scale9Rect = v.scale9Rect,
				-- 	},
				-- })
				-- sp:setContentSize(cc.size(v.width, v.height))

				-- local sp = newSprite({
				-- 	width = v.width,
				-- 	height = v.height,
				-- 	style = {
				-- 		src = v.src,
				-- 		scale9Rect = v.scale9Rect,
				-- 	},
				-- })

				local sp = newImage({
					width = v.params.width,
					height = v.params.height,
					anchorPoint = POINT_LEFT_BOTTOM,
					style = {
						src = v.params.src,
						scale9Rect = v.params.scale9Rect,
					},
				})
				-- sp:setContentSize(cc.size(v.width, v.height))

				-- local sp = cc.Sprite:create(v.params.src)
				-- if v.params.scale then
				-- 	sp:setScale(v.params.scale)
				-- else
				-- 	if v.params.width and v.params.width > 0 then
				-- 		sp:setScaleX(v.params.width/sp:getContentSize().width)
				-- 	end
				-- 	if v.params.height and v.params.height > 0 then
				-- 		sp:setScaleY(v.params.height/sp:getContentSize().height)
				-- 	end
				-- end

				sp:setContentSize(cc.size(sp:getContentSize().width * sp:getScaleX(), sp:getContentSize().height * sp:getScaleY()))
				local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, sp)
				self:pushBackElement(element)

			elseif v.kind == "bmfont" then
				local bmFontLabel = newBMFontLabel(v.params)
				local size = bmFontLabel:getContentSize()

				local additionalKerning = 0
				if v.params.style then
					additionalKerning = v.params.style.additionalKerning or 0
				end
				local len = StringUtil.getLength(v.params.text)
				
				size.width = size.width + (v.params.widthOffset or 0) + additionalKerning * len
				size.height = size.height + (v.params.heightOffset or 0)

				local container = newNode()
				container:setContentSize(size)
				container:addChild(bmFontLabel)

				local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, container)
				self:pushBackElement(element)		


			elseif v.kind == "br" then
				local lineHeight = finalParams.style.lineHeight
				if lineHeight == false then
					lineHeight = finalParams.style.size
				end
				local element = ccui.RichElementNewLine:create(lineHeight)
				self:pushBackElement(element)
			elseif v.kind == "node" then
				local creator
				-- print(168, "node")
				-- printTable(168, v)
				if type(v.params.creator) == "string" then
					creator = assert(loadstring("return "..v.params.creator))()
					if type(creator) == "function" then
						local creatorParams
						if type(v.params.creatorParams) == "string" then
							creatorParams = assert(loadstring("return "..v.params.creatorParams))()
						end
						local node = creator(creatorParams)
						if not tolua.isnull(node) then
							local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, node)
							self:pushBackElement(element)
						end
					end
				end
			elseif v.kind == "ming" then--模型的名字框，有跨服爵位时才显示，HtmlUtil.newNameNode
				creator = assert(loadstring("return "..v.params.creator))()
				if type(creator) == "function" then
					local node = creator(v.params.creatorParams)
					if not tolua.isnull(node) then
						local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, node)
						self:pushBackElement(element)
					end
				end
			end
		end

		if finalParams.updateSizeNow then
			self:formatText()
		end
	end

	--设置文本的宽度
	function richText:setWidth(value)
		if finalParams.width ~= value then
			finalParams.width = value
			if finalParams.width > 0 then
				richText:setContentSize(cc.size(finalParams.width, finalParams.height))
				richText:ignoreContentAdaptWithSize(false)
			end
		end
	end

	function richText:setString(text)
		richText:setText(text)
	end

	function richText:getString()
		return richText:getText()
	end

	function richText:setColor(color, forceUpdate)
		finalParams.style.color = color
		if forceUpdate then
			local text = self:getText()
			self:setText("")
			self:setText(text)
		end
	end

	richText:appendText(finalParams.text)

	return richText
end
