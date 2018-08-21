module("THSTG.UI", package.seeall)

--滚动条皮肤
HSCROLLBAR_SCROLL_SKIN = {
	src = "",--ResManager.getUIRes(UIType.SCROLLBAR, "h_progress_default"),
	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
}
--滚动条背景皮肤
HSCROLLBAR_BG_SKIN = {
	src = "",-- ResManager.getUIRes(UIType.SCROLLBAR, "h_bg_default"),
	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
}
--滚动条点击按钮皮肤
HSCROLLBAR_CLICK_SKIN =
	{
		normal = {
			skin = {
				src = "",-- ResManager.getUIRes(UIType.SCROLLBAR, "v_bg_default"),
				scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
			}
		}--"h_click_default")}},
	}

--滚动条皮肤
VSCROLLBAR_SCROLL_SKIN = {
	src = "",-- ResManager.getUIRes(UIType.SCROLLBAR, "v_progress_default"),
	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
}
--滚动条背景皮肤
VSCROLLBAR_BG_SKIN = {
	src = "",-- ResManager.getUIRes(UIType.SCROLLBAR, "v_bg_default"),
	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
}
--滚动条点击按钮皮肤
VSCROLLBAR_CLICK_SKIN =
	{
		normal = {
			skin = {
				src = "",-- ResManager.getUIRes(UIType.SCROLLBAR, "v_bg_default"),
				scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
			}
		}--v_click_default")}},
	}

--滚动条点击按钮高亮皮肤
SCROLLBAR_CLICK_HIGHLIGHT_SKIN = {

	}

--[[
@params minLength  [number]  可视区域长度
@parmas maxLength  [number]  内容长度
@params direction  [number]    滚动条方向， 默认值ccui.ScrollViewDir.vertical
@parmas onChange   [function]    滚动条位置改变事件
@parmas style   	[table]    滚动条样式
	= {
			clickStyle = THSTG.UI.HSCROLLBAR_CLICK_SKIN
			scrollBgStyle = THSTG.UI.HSCROLLBAR_BG_SKIN
			scrollFrontStyle = THSTG.UI.HSCROLLBAR_SCROLL_SKIN
	}
]]
function newScrollBar(params)
	local function tipLog(str)
		print("newScrollBar: "..str)
	end

	local rootFather = THSTG.UI.newWidget()

	local root = nil

	local finalParam = {
		minLength = 250,
		maxLength = 500,
		curPercent = 0,
		onChange = function() end,
		direction = ccui.ScrollViewDir.vertical,
		anchorPoint = clone(THSTG.UI.POINT_LEFT_BOTTOM),
		style = {
			clickStyle = clone(THSTG.UI.HSCROLLBAR_CLICK_SKIN),
			scrollBgStyle = clone(THSTG.UI.HSCROLLBAR_BG_SKIN),
			scrollFrontStyle = clone(THSTG.UI.HSCROLLBAR_SCROLL_SKIN),
		}
	}

	THSTG.TableUtil.mergeA2B(params, finalParam)
	
	if finalParam.direction == ccui.ScrollViewDir.vertical then
		root = ccui.VBox:create()
	else
		root = ccui.HBox:create()
	end
	root:setAnchorPoint(THSTG.UI.POINT_LEFT_BOTTOM)
	rootFather:addChild(root)

	local privateData = {}
	privateData.minLength = finalParam.minLength
	privateData.maxLength = finalParam.maxLength
	privateData.curPercent = finalParam.curPercent
	privateData.bgWidth = finalParam.minLength
	privateData.scrollWidth = 50
	privateData.minScrollWidth = 30
	privateData.onChange = finalParam.onChange
	privateData.step = 10
	local x, y = params.x or 0, params.y or 0


	--[[初始化]]
	function privateData.init()
		
		local clickStyle = finalParam.style.clickStyle
		local scrollBgStyle = finalParam.style.scrollBgStyle
		local scrollFrontStyle = finalParam.style.scrollFrontStyle
		local flippedFunc = "setFlippedX"
		local isV = false
		if finalParam.direction == ccui.ScrollViewDir.vertical then
			clickStyle = clickStyle or THSTG.UI.VSCROLLBAR_CLICK_SKIN
			scrollBgStyle = scrollBgStyle or THSTG.UI.VSCROLLBAR_BG_SKIN
			scrollFrontStyle = scrollFrontStyle or THSTG.UI.VSCROLLBAR_SCROLL_SKIN
			flippedFunc = "setFlippedY"
			isV = true
		else
			clickStyle = clickStyle or THSTG.UI.HSCROLLBAR_CLICK_SKIN
			scrollBgStyle = scrollBgStyle or THSTG.UI.HSCROLLBAR_BG_SKIN
			scrollFrontStyle = scrollFrontStyle or THSTG.UI.HSCROLLBAR_SCROLL_SKIN
		end

		local nodeStepToStart = THSTG.UI.newButton({
			text = "",
			x = 0, y = 0,
			style = clickStyle,
			onClick = privateData.onBarClick
		})
		--nodeStepToStart:setPressedActionEnabled(true)
		nodeStepToStart[flippedFunc](nodeStepToStart, true)
		local nodeStepToEnd = THSTG.UI.newButton({
			text = "",
			x = 0, y = 0,
			style = clickStyle,
			onClick = privateData.onBarClick
		})
		--nodeStepToEnd:setPressedActionEnabled(true)


		local bgCapInsets, bgOrgSize = THSTG.UI.skin2CapInsets(scrollBgStyle)
		local nodeBackScroll = ccui.ImageView:create(scrollBgStyle.src)
		nodeBackScroll:setScale9Enabled(true)
		nodeBackScroll:setCapInsets(bgCapInsets)

		local frontbgCapInsets, frontbgOrgSize = THSTG.UI.skin2CapInsets(scrollFrontStyle)
		local nodeFrontScroll = ccui.ImageView:create(scrollFrontStyle.src)
		nodeFrontScroll:setScale9Enabled(true)
		nodeFrontScroll:setCapInsets(frontbgCapInsets)
		if isV then
			nodeFrontScroll:setAnchorPoint(THSTG.UI.POINT_CENTER_BOTTOM)
			nodeFrontScroll:setPosition(cc.p(bgOrgSize.width / 2, 0))
		else
			nodeFrontScroll:setAnchorPoint(THSTG.UI.POINT_LEFT_CENTER)
			nodeFrontScroll:setPosition(cc.p(0, bgOrgSize.height / 2))
		end

		nodeBackScroll:addChild(nodeFrontScroll)

		privateData.nodeStepToStart = nodeStepToStart
		privateData.nodeBackScroll = nodeBackScroll
		privateData.nodeFrontScroll = nodeFrontScroll
		privateData.nodeStepToEnd = nodeStepToEnd

		root:addChild(nodeStepToStart)
		root:addChild(nodeBackScroll)
		root:addChild(nodeStepToEnd)
		root:setTouchEnabled(true)

		nodeFrontScroll:setTouchEnabled(true)
		nodeFrontScroll:addTouchEventListener(privateData.onFrontScrollMove)

		rootFather:setPosition(cc.p(x, y))
		rootFather:setAnchorPoint(finalParam.anchorPoint)

		privateData.bgWidth = privateData.minLength - privateData.getClickNodeLength()
		if privateData.bgWidth < privateData.minScrollWidth then
			privateData.bgWidth = privateData.minScrollWidth
		end
		privateData.resetLayout()
	end

	-----------------------------------------------------------------------------
	--核心函数
	--[[滚动条位置发生改变触发的动作
	--new: 新的位置 0 -100
	--noTrigger:  是否触发onChange回调
	]]
	function privateData.onPositionChange(new, noTrigger)
		local old = privateData.curPercent
		privateData.curPercent = new
		local offsetWidth = (new - old) * privateData.widthPerPercent()
		local oldx, oldy = privateData.nodeFrontScroll:getPosition()

		if finalParam.direction == ccui.ScrollViewDir.vertical then
			privateData.nodeFrontScroll:setPosition(cc.p(oldx, (oldy - offsetWidth)))
		else
			privateData.nodeFrontScroll:setPosition(cc.p(oldx + offsetWidth, oldy))
		end

		if privateData.onChange and not noTrigger  then
			privateData.onChange(rootFather, privateData.curPercent, old)
		end
	end

	--[[内容长度发生改变]]
	function privateData.onMaxLengthChange(new)
		if new >= 0  then
			privateData.maxLength = new
			if privateData.maxLength > privateData.minLength then
				if params.autoHide then
					root:setVisible(false)
				else
					root:setVisible(true)
				end

				privateData.resetLayout()
			else
				root:setVisible(false)
			end
		else
			tipLog("maxLength value must over 0, "..tostring(new))
		end
	end

	--[[可视长度发生改变]]
	function privateData.onMinLenChange(new)
		if new > 0 then
			privateData.minLength = new
			if privateData.maxLength > privateData.minLength then
				if params.autoHide then
					root:setVisible(false)
				else
					root:setVisible(true)
				end
				privateData.resetLayout()
			else
				root:setVisible(false)
			end
		else
			tipLog("minLength value must over 0, "..tostring(new))
		end
	end

	--[[重新计算相关参数, minLength, maxLength, minScrollWidth, bgWidth 改变时，调用这函数]]
	function privateData.resetLayout()
		if privateData.maxLength <= privateData.minLength then
			root:setVisible(false)
		end

		local scrollWidth = privateData.minLength / privateData.maxLength * privateData.bgWidth
		if scrollWidth < privateData.minScrollWidth then
			scrollWidth = privateData.minScrollWidth
		end
		privateData.scrollWidth = scrollWidth
		local offset = privateData.curPercent * privateData.widthPerPercent()
		local x, y = privateData.nodeFrontScroll:getPosition()
		local backContent = privateData.nodeBackScroll:getContentSize()
		local frontContent = privateData.nodeFrontScroll:getContentSize()
		if finalParam.direction == ccui.ScrollViewDir.vertical then
			privateData.nodeFrontScroll:setPosition(cc.p(x, (privateData.bgWidth - privateData.scrollWidth) - offset))
			privateData.nodeBackScroll:setContentSize(cc.size(backContent.width, privateData.bgWidth))
			privateData.nodeFrontScroll:setContentSize(cc.size(frontContent.width, privateData.scrollWidth))
		else
			privateData.nodeFrontScroll:setPosition(cc.p(offset, y))
			privateData.nodeBackScroll:setContentSize(cc.size(privateData.bgWidth, backContent.height))
			privateData.nodeFrontScroll:setContentSize(cc.size(privateData.scrollWidth, frontContent.height))
		end

		rootFather:setContentSize(privateData.getLayoutContentSize())
		root:setContentSize(privateData.getLayoutContentSize())
	end

	--[[处理点击事件]]
	function privateData.onBarClick(node, eventype)
		--tipLog("onBarClick, "..tostring(eventype))
		if node == privateData.nodeStepToStart then
			privateData.moveScrollByOffset(-privateData.step)
		elseif node == privateData.nodeStepToEnd then
			privateData.moveScrollByOffset(privateData.step)
		end
	end

	--[[处理拖动事件]]
	function privateData.onFrontScrollMove(node, eventype)

		--tipLog("onFrontScrollMove, "..tostring(eventype))
		if eventype == ccui.TouchEventType.began then
			privateData.scrollLastPoint = node:getTouchBeganPosition()
		elseif eventype == ccui.TouchEventType.moved then
			local p = node:getTouchMovePosition()
			if not privateData.scrollLastPoint then
				privateData.scrollLastPoint = p
			else
				local nodeLastP = privateData.scrollLastPoint
				local nodeCurP = p
				local offset = 0
				if finalParam.direction == ccui.ScrollViewDir.vertical then
					offset = nodeCurP.y - nodeLastP.y
					offset = -offset
				else
					offset = nodeCurP.x - nodeLastP.x
				end

				privateData.moveScrollByOffset(offset / privateData.widthPerPercent())
				privateData.scrollLastPoint = p
			end
			--tipLog("onFrontScrollMove hit")
		elseif eventype == ccui.TouchEventType.ended then

		elseif eventype == ccui.TouchEventType.canceled then

		end

	end

	------------------------------------------------------------------------------

	--[[获取点击按钮总长]]
	function privateData.getClickNodeLength()
		local nodeStepToStartSize = privateData.nodeStepToStart:getContentSize()
		local nodeStepToEndSize = privateData.nodeStepToEnd:getContentSize()
		local len = 0
		if finalParam.direction == ccui.ScrollViewDir.vertical then
			len = nodeStepToEndSize.height + nodeStepToStartSize.height
		else
			len = nodeStepToEndSize.width + nodeStepToStartSize.width
		end
		return len
	end
	--[[计算父节点大小]]
	function privateData.getLayoutContentSize()
		local nodeStepToStartSize = privateData.nodeStepToStart:getContentSize()
		local nodeStepToEndSize = privateData.nodeStepToEnd:getContentSize()
		local nodeBackScrollSize = privateData.nodeBackScroll:getContentSize()

		local ret = nodeStepToStartSize
		if finalParam.direction == ccui.ScrollViewDir.vertical then
			if ret.width < nodeStepToEndSize.width then
				ret.width = nodeStepToEndSize.width
			end
			if ret.width < nodeBackScrollSize.width then
				ret.width = nodeBackScrollSize.width
				--tipLog("nodeBackScrollSize.width ："..tostring(nodeBackScrollSize.width ))
			end
			ret.height = ret.height + nodeBackScrollSize.height + nodeStepToEndSize.height
			--tipLog("getLayoutContentSize height: "..tostring(ret.height).." width: "..tostring(ret.width))
		else
			if ret.height < nodeStepToEndSize.height then
				ret.height = nodeStepToEndSize.height
			end
			if ret.height < nodeBackScrollSize.height then
				ret.height = nodeBackScrollSize.height
			end
			ret.width = ret.width + nodeBackScrollSize.width + nodeStepToEndSize.width
			--tipLog("getLayoutContentSize width: "..tostring(ret.width).." height: "..tostring(ret.height))
		end

		return ret
	end

	function privateData.widthPerPercent()
		return (privateData.bgWidth - privateData.scrollWidth) / 100
	end

	function privateData.lengthPerWidth()
		return privateData.maxLength / privateData.scrollWidth
	end
	function privateData.widthPerLength()
		return privateData.scrollWidth / privateData.maxLength
	end
	function privateData.lengthToScrollWidth(length)
		return length * privateData.widthPerLength
	end
	function privateData.scrollWidthTolength(width)
		return width * privateData.lengthPerWidth
	end
	function privateData.getCurOffsetRange()
		local min, max = 0
		local minPos = 0
		local maxPos = 100 - privateData.curPercent
		min = minPos - privateData.curPercent
		max = maxPos
		return min, max
	end
	function privateData.moveScrollByOffset(offset)
		local minOffset, maxOffset = privateData.getCurOffsetRange()
		if minOffset - offset > 0 then
			offset = minOffset
		end
		if offset - maxOffset > 0 then
			offset = maxOffset
		end
		--tipLog("offset: "..tostring(offset))
		if offset ~= 0 then

			privateData.onPositionChange(privateData.curPercent + offset)
		end
	end

	-------------------------------------------------------------------------------
	--外部接口
	--[[注册滚动条滚动事件]]
	function rootFather:registerScrollBarChangeHandler(handler)
		privateData.onChange = handler
	end


	--[[设置滚动条位置
	percent: 0 - 100
	]]
	function rootFather:setCurPercent(percent, noTrigger)
		if percent >= 0 and percent <= 100 then
			privateData.onPositionChange(percent, noTrigger)
		else
			tipLog("setcurPercent, percent 0-100 value is:"..tostring(percent))
		end
	end

	--[[获取滚动位置 0 - 100]]
	function rootFather:getCurPercent()
		return privateData.curPercent
	end

	--[[设置最大长度]]
	function rootFather:setMaxLength(length)
		privateData.onMaxLengthChange(length)
	end

	--[[设置最小长度]]
	function rootFather:setMinLength(length)
		privateData.onMinLenChange(length)
	end

	--[[获取最大长度]]
	function rootFather:getMaxLength()
		return privateData.maxLength

	end

	--[[获取最小长度]]
	function rootFather:getMinLength()
		return privateData.minLength
	end
	-------------------------------------------------------------------------------
	privateData.init()
	return rootFather
end
