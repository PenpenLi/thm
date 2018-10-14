module("THSTG.UICustom", package.seeall)

--[[
params:
	nilText = ""
	textGetter[function]
	onSelectedChanged[function]
	maxItemShow = 7
	isUp = false 朝上
]]

local TOPTIPMANAGER_TAG = 10001
local LOCAL_Z = 9998

local function s_newTouchWiget(params)
	local widget = ccui.Widget:create()
	widget:setTouchEnabled(true)
	widget:setContentSize(cc.size(params.width or 0, params.height or 0))
	widget:setPosition(cc.p(params.x or 0, params.y or 0))
	widget:setAnchorPoint(params.anchorPoint or cc.p(UI.POINT_LEFT_BOTTOM))
	widget:onTouch(function (event)
		if widget.onTouch then
			widget:onTouch(event)
		end
	end)
	widget:setSwallowTouches(params.isSwallow or false)

	return widget
end

local function s_createManager()
	local manager = s_newTouchWiget({
		width = display.width,
		height = display.height,
	})
	LayerManager.loadingLayer:addChild(manager)
	function manager:onTouch(event)
		self:removeFromParent()
		return false
	end

	return manager
end

function showDropDown(node)
	local manager = s_createManager()
	manager:addChild(node)
	return manager
end
--[[
params = {
	style = {
		src = <imgSrc> -- 选择项底图
		bg = <imgSrc> -- 控件展示框底图
		popBg = <imgSrc> 弹窗框底图
		color = <>
	}
	width = num
	height = num
	itemHeight = num
	maxItemShow = num
	isUp = bool
	colorGetter = <function>
	textGetter = <function>
	redDotDataGetter = <function>
	dataProvider = {}
}
]]--
local function s_createSelecter(params)

	params = clone(params or {})
	params.width = params.width or 200
	params.height = params.height or 38
	params.style = params.style or {}

	local itemColor = (params.style and params.style.color) or UI.htmlColor2C3b("#0d2046")
	local itemFontSize = (params.style and params.style.size) or UI.FONT_SIZE_SMALL
	local getter = function(v, i)
		if v and params.textGetter then
			return params.textGetter(v, i)
		end
		return v
	end

	local textColor = itemColor or UI.htmlColor2C3b("#0d2046")
	local colorGetter = function(v,i)
		if v and params.colorGetter then
			return params.colorGetter(v, i)
		else
			if params.textColor then
				return params.textColor[i]
			end
		end
		return textColor
	end

	local redDotDataGetter = function(v,i)
		if v and params.redDotDataGetter then
			return params.redDotDataGetter(v, i)
		end
		return nil
	end

	local info = getTraceback()
	local privateData = {}
	privateData.dataProvider = params.dataProvider or {}
	local function dropOperate(sender)--下拉UI
		if __PRINT_TRACK__ then
			print(__PRINT_TYPE__, info)
		end
		local data = privateData.dataProvider
		local itemHeight = params.itemHeight or 34
		local maxItem = params.maxItemShow or 7
		local width = params.width
		local height = math.min(maxItem, #data) * itemHeight
		if height == 0 then
			height = itemHeight
		end 
		local pt = sender:convertToWorldSpace(cc.p(0, 0))
		local anchorPoint = cc.p(0, 1)
		if params.isUp then
			pt.y = pt.y + params.height
			anchorPoint = cc.p(0, 0)
		end
		local node = UI.newWidget{
			x = pt.x, y = pt.y,
			width = width, height = height + 12,
			anchorPoint = anchorPoint,
		}

		local bgImage = ResManager.getUIRes(UIType.DROP_DOWN, "drop_frame")
		if params.style and params.style.bg then
			bgImage = params.style.bg
		end
		if params.style and params.style.popBg then
			bgImage = params.style.popBg
		end 
		local bg = UI.newScale9Sprite{
			width = width,
			height = height + 12,
			anchorPoint = cc.p(0, 0),
			style = {
				src = bgImage,
				scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
			}
		}
		node:addChild(bg, -1)

		local scrollView = UI.newScrollView{
			y = 4,
			width = width,
			height = height,
		}
		scrollView:setBounceEnabled(false)
		local contentH = #data * itemHeight
		if contentH == 0 then
			contentH = itemHeight
		end 
		scrollView:setInnerContainerSize(cc.size(width, contentH))
		node:addChild(scrollView)
		scrollView:setSwallowTouches(false)
		local labels = {}
		if #data == 0 then
			local bg = nil
			if params.style and params.style.src then
				bg = UI.newImage({
					x = params.itemX or 10,
					y = (1 - 0.5) * itemHeight,
					width = params.itemWidth,
					height = params.itemHeight,
					anchorPoint = cc.p(0, 0.5),
					style = {
						scale9Rect = params.style.scale9Rect or {left = 10, right = 10, top = 10, bottom = 10},
						src = params.style.src,
					}
				})
				scrollView:addChild(bg)
			end
			local labelX = width / 2
			local labelY = 0.5* itemHeight + 4
			local bgSize=cc.size(0,0)
			if bg then
				bgSize = bg:getContentSize()
				labelX = bgSize.width / 2
				labelY = bgSize.height / 2
			end
			--左对齐
			if params.alignLeft then
				labelX = params.alignLeft
				labelY = bg and bgSize.height / 2 or  ((i - 0.5) * itemHeight + 4)
			end
			--字体颜色
			local textColor = UI.htmlColor2C3b("#0d2046")
			local anchorPoint = params.alignLeft and UI.POINT_LEFT_CENTER or UI.POINT_CENTER
			local label = UI.newRichText{
				x = labelX,
				y = labelY,
				anchorPoint = anchorPoint,
				text = params.noneContentTip or Language.getString(335900),
				style = {
					color = textColor,
					outline = params.style.outline,
					outlineColor = params.style.outlineColor,
				}
			}
			if bg then
				bg:addChild(label)
			else
				scrollView:addChild(label)
			end
		end 
		for i, v in ipairs(data) do
			--背景
			local bg = nil
			if params.style and params.style.src then
				bg = UI.newImage({
					x = params.itemX or 10,
					y = (i - 0.5) * itemHeight,
					width = params.itemWidth,
					height = params.itemHeight,
					anchorPoint = cc.p(0, 0.5),
					style = {
						scale9Rect = params.style.scale9Rect or {left = 10, right = 10, top = 10, bottom = 10},
						src = params.style.src,
					}
				})
				scrollView:addChild(bg)
			end

			local labelX = width / 2
			local labelY = (i - 0.5) * itemHeight + 4

			local bgSize=cc.size(0,0)
			if bg then
				bgSize = bg:getContentSize()
				labelX = bgSize.width / 2
				labelY = bgSize.height / 2
			end
			--左对齐
			if params.alignLeft then
				labelX = params.alignLeft
				labelY = bg and bgSize.height / 2 or  ((i - 0.5) * itemHeight + 4)
			end

			--字体颜色
			local anchorPoint = params.alignLeft and UI.POINT_LEFT_CENTER or UI.POINT_CENTER
			local label = UI.newRichText{
				--x = 10, y = (i - 0.5) * itemHeight + 4,
				--anchorPoint = cc.p(0, 0.5),
				x = labelX,
				y = labelY,
				anchorPoint = anchorPoint,
				text = getter(data[#data - i + 1], #data - i + 1),
				style = {
					color = colorGetter(data[#data - i + 1], #data - i + 1),
					outline = params.style.outline,
					outlineColor = params.style.outlineColor,
				}
			}

			--加红点
			local redDotData = redDotDataGetter(data[#data - i + 1], #data - i + 1)
			if redDotData then
				local redDot = UIPublic.newRedDot(redDotData)
				if redDotData.x and redDotData.y then
					if bg then bg:addChild(redDot)
					else scrollView:addChild(redDot)
					end
				else
					redDot:setPosition(cc.p(label:getContentSize().width + 10, label:getContentSize().height/2))
					label:addChild(redDot)
				end
			end


			if bg then
				bg:addChild(label)
			else
				scrollView:addChild(label)
			end
			table.insert(labels, label)
		end

		local curLabel = false
		local function setCurrent(index)
			if curLabel then
				-- curLabel:setColor(itemColor, true)
				curLabel = false
			end

			if index then
				curLabel = labels[index]
				-- curLabel:setColor(itemColor, true)
			end
		end

		local cancled = false
		node:setTouchEnabled(true)
		node:onTouch(function(event)
			local ptTouch = nil
			local close = false
			local ptTouch1 = node:getTouchBeganPosition()
			local ptTouch2 = node:getTouchMovePosition()
			if event.name == "began" then
				cancled = false
				ptTouch = ptTouch1
			elseif event.name == "moved" then
				ptTouch = ptTouch2
				if math.abs(ptTouch2.y - ptTouch1.y) > 4 then
					setCurrent(false)
					cancled = true
				end
			else
				close = true
				ptTouch = node:getTouchEndPosition()
			end

			if cancled and #data > maxItem then
				return
			end

			local selected = nil
			if #labels > 0 then
				if node:hitTest(ptTouch) then
					local ptLocal = node:convertToNodeSpace(ptTouch)
					local y = ptLocal.y - scrollView:getInnerContainerPosition().y
					selected = cc.clampf(math.ceil(y / itemHeight), 1, #labels)
					setCurrent(selected)
				end
			end 
			if close then
				if selected then
					privateData.setSelectedIndex(1 + #data - selected)
				end
				manager:removeFromParent()
			end
		end)

		manager = showDropDown(node)
	end

	local node = UI.newImage{
		x = params.x, 
		y = params.y,
		width = params.width, 
		height = params.height,
		anchorPoint = cc.p(0, 0.5),
		style = {
			src = params.style.bg or ResManager.getUIRes(UIType.DROP_DOWN, "drop_frame"),
			scale9Rect = params.style.scale9Rect or {left = 5, right = 5, top = 5, bottom = 5}
		},
		onClick = dropOperate
	}

	local labelText = getter(privateData.dataProvider[1], 1)
	if params.nilText then
		labelText = params.nilText
	end

	local defaultLabel = UI.newRichText{
		x = params.labelX or 10, 
		y = params.height * 0.5,
		anchorPoint = params.labelAnchorPoint or cc.p(0, 0.5),
		text = params.defaultText,
		style = {
			size = itemFontSize,
			color = itemColor,
			outline = params.style.outline,
			outlineColor = params.style.outlineColor,
		}
	}
	node:addChild(defaultLabel)

	local label = UI.newRichText{
		x = params.labelX or 10, 
		y = params.height * 0.5,
		anchorPoint = params.labelAnchorPoint or cc.p(0, 0.5),
		text = labelText,
		style = {
			size = itemFontSize,
			color = itemColor,
			outline = params.style.outline,
			outlineColor = params.style.outlineColor,
		}
	}
	node:addChild(label)

	local img = UI.newSprite{
		x = params.width - params.height * 0.5,
		y = params.height * 0.5,
		src = params.style.arrowBg or ResManager.getUIRes(UIType.DROP_DOWN, "drop_btn")
	}
	local scale = params.height / 34
	img:setScale(scale)
	node:addChild(img)

	local arrow = UI.newSprite{
		x = params.width - params.height * 0.5,
		y = params.height * 0.5 - 2,
		src = params.style.arrow or ResManager.getUIRes(UIType.DROP_DOWN, "drop_arrow")
	}
	arrow:setScale(scale)
	node:addChild(arrow)

	--
	function node:setDataProvider(data, updateSel)
		privateData.dataProvider = data
		if updateSel then
			privateData.setSelectedIndex(1, true)
		end
	end

	function node:setSelectedIndex(index, force)
		privateData.setSelectedIndex(index, force)
	end

	function node:getSelectedIndex()
		return privateData.index
	end
	function node:getSelectedValue(...)
		if privateData.index then
			return privateData.dataProvider[privateData.index]
		end
		return false
	end

	function node:setEnabled(flag)
		node:setTouchEnabled(flag)
		arrow:setDiscolored(not flag)
		img:setDiscolored(not flag)
	end

	function node:setText(text)
		label:setText(text)
	end

	function node:refresh()
		privateData.refresh()
	end
	
	function privateData.refresh()
		if tolua.isnull(node) then
			return
		end
		
		local index = privateData.index
		local value = nil
		if index then
			value = privateData.dataProvider[index]

			label:setText(getter(value, index))
		else
			label:setText(params.nilText or "")
		end

		local textColor = itemColor

		if params.colorGetter then
			if index then
				if value then
					textColor = params.colorGetter(value, index)
				end
			end	
		else
			if params.textColor then
				textColor = params.textColor[index]
			end
		end

		if textColor then
			label:setColor(textColor, true)
		else
			label:setColor(itemColor, true)
		end

	end

	function privateData.setSelectedIndex(index, force)
		if tolua.isnull(node) then
			return
		end
		if not force and privateData.index == index then
			return
		end

		local lastIndex = privateData.index
		local lastValue = nil
		if lastIndex then
			lastValue = privateData.dataProvider[lastIndex]
		end
		local value = privateData.dataProvider[index]
		
		privateData.index = index

		local needRefresh = true
		if params.onSelectedChanged then
			needRefresh = (params.onSelectedChanged(node, index, value, lastIndex, lastValue)~=false)
		end

		if needRefresh then
			privateData.refresh()
		else
			--为了兼容以前逻辑,仅当回调有返回值为false时,index还原
			privateData.index = lastIndex
		end
		
		defaultLabel:setVisible(false)
	end

	return node
end
--param
-- onSelectedChanged
--
function newDropDown(...)
	return s_createSelecter(...)
end
