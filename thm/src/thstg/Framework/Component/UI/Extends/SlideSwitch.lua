module("UI", package.seeall)

--默认样式
SLIDE_SWITCH_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	width = 200,
	height = 52,
	anchorPoint = UI.POINT_LEFT_BOTTOM,
	itemGap = 4,
	isOn = true,
	textON = "ON",
	textOFF = "OFF",
	style = {
		padding = {left = 2, right = 2, top = 2, bottom = 2},
		thumbSkin = {
			src = "",-- ResManager.getResSub(ResType.UIBASE,UIBaseType.SWITCH, "switch_cover"),
			scale9Rect = {left = 6, right = 6, top = 6, bottom = 6}
		},
		bgSkin = {
			src = "",-- ResManager.getResSub(ResType.UIBASE,UIBaseType.SWITCH, "switch_bg"),
			scale9Rect = {left = 5, right = 5, top = 5, bottom = 5}
		},
		text = {
			normal = {color = UI.HTML_COLOR_GRAY_A, size = UI.FONT_SIZE_BIGGER},
			selected = {color = UI.HTML_COLOR_WHITE, size = UI.FONT_SIZE_BIGGER},
		}
	},
	itemTemplate = function(data, size, labelStyle)
		local node = cc.Node:create()
		node:setContentSize(size)

		local label = UI.newLabel({
			anchorPoint = UI.POINT_CENTER,
			text = (data or "label"),
			x = size.width / 2, y = size.height / 2,
			style = labelStyle,
		})
		node:addChild(label)

		function node:setLabelColor(value)
			label:setColor(value)
		end

		return node
	end
}

--[[
创建滑块节点
@param  backNode  [cc.Node]  背景节点
@param	slideNode [cc.Node]  滑动节点
@param	onChange  [function(target, isLeft)]
@param	padding   [table] 	滑块4边间隔
]]
local function newSlideSwitchNode(params)
	params = params or {}

	assert(tolua.cast(params.backNode, "cc.Node") ~= nil , "newSlideSwitchNode params backNode must be cc.Node")
	assert(tolua.cast(params.slideNode, "cc.Node") ~= nil , "newSlideSwitchNode params slideNode must be cc.Node")

	local padding = {left = 0, right = 0, top = 0, bottom = 0}
	TableUtil.mergeA2B(params.padding, padding)

	local backNode = params.backNode
	local slideNode = params.slideNode
	slideNode:setAnchorPoint(UI.POINT_LEFT_BOTTOM)
	slideNode:setPosition(padding.left, padding.bottom)

	local slideSwitchNode = nil

	local privateData = {}
	privateData.isLeft = nil  --是否在左边
	privateData.isMove = false   --是否移动
	privateData.lastPos = nil  --
	privateData.isMoveToRight = nil
	function privateData.onTouch(event)
		if event.name == "began" then
			local pos = event.target:getTouchBeganPosition()
			privateData.lastPos = pos
		elseif event.name == "moved" then
			privateData.isMove = true
			local pos = event.target:getTouchMovePosition()
			local offset = cc.pSub(pos, privateData.lastPos)
			local slideNodeP = cc.p(slideNode:getPosition())
			slideNodeP.x = math.min(slideNodeP.x + offset.x, privateData.getSlideMaxOffset())
			slideNodeP.x = math.max(slideNodeP.x, privateData.getSlideMinOffset())
			slideNode:setPosition(slideNodeP)
			privateData.lastPos = pos
		else
			local pos = event.target:getTouchEndPosition()
			local slideNodeP = cc.p(slideNode:getPosition())
			local slideNodeS = slideNode:getContentSize()
			local backNodeS = backNode:getContentSize()
			if privateData.isMove then
				privateData.applySlideAction((privateData.isLeft and (slideNodeP.x - privateData.getSlideMinOffset()) + slideNodeS.width <= privateData.getSlideWidth() / 2) or (not privateData.isLeft and slideNodeP.x - privateData.getSlideMinOffset() < privateData.getSlideWidth() / 2))
			else
				if privateData.isMoveToRight == nil then
					privateData.applySlideAction(not privateData.isLeft)
				else
					privateData.applySlideAction(not privateData.isMoveToRight)
				end

			end

			privateData.isMove = false
		end
	end

	function privateData.applySlideAction(isLeft, withoutAction)
		local tarPos = cc.p(slideNode:getPosition())
		privateData.isMoveToRight = isLeft
		if isLeft then
			tarPos.x = privateData.getSlideMinOffset()
		else
			tarPos.x = privateData.getSlideMaxOffset()
		end

		slideNode:stopAllActions()
		if not withoutAction then
			slideNode:moveTo({
				x = tarPos.x, time = 0.2,
				onComplete = function ()
					privateData.setLeft(isLeft)
				end
			})
		else
			slideNode:setPositionX(tarPos.x)
			privateData.setLeft(isLeft)
		end
	end

	function privateData.getSlideMaxOffset()
		local slideNodeS = slideNode:getContentSize()
		return math.max(privateData.getSlideMinOffset(), privateData.getSlideMinOffset() + privateData.getSlideWidth() - slideNodeS.width)
	end

	function privateData.getSlideMinOffset()
		return padding.left
	end

	function privateData.getSlideWidth()
		local size = backNode:getContentSize()
		return math.max(0, size.width - padding.left - padding.right)
	end

	function privateData.setLeft(value)
		if value ~= privateData.isLeft then
			privateData.isLeft = value
			if params.onChange then
				params.onChange(slideSwitchNode, privateData.isLeft)
			end
		end
	end

	slideSwitchNode = UI.newControlButton({
		x = params.x, y = params.y,
		isTouchAction = false,
		onTouch = privateData.onTouch,
		curFaceNode = backNode,
	})

	slideSwitchNode:addChild(slideNode)

	function slideSwitchNode:setLeft(value)
		privateData.applySlideAction(value, true)
	end

	function slideSwitchNode:isLeft()
		return privateData.isLeft
	end

	function slideSwitchNode:getSlidePosition()
		return slideNode:getPosition()
	end

	slideSwitchNode:setLeft(params.isLeft or true)

	return slideSwitchNode
end


--[[
创建单个显示可折叠的容器

@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		
@param	textON			#string		开启状态文本	
@param	textOFF			#string		关闭状态文本
@param	itemGap			[cc.p]		两个临近项间的间隔
@param	itemTemplate	[function]	创建每一个项目的模板，对应到dataProvider中的每一项
@param	isOn			[bool]		选中左边，默认为true
@param	onChange		[function]	变更当前选择项时的回调函数，格式如：function callback(params) end，
									其中params格式如：{currentIndex:当前选中项的索引[1-N], lastIndex = 变更前选择的项[1-N], tag = 对应accordion的tag}
@param  slideNode       [cc.Node]   滑块节点， 可为nil
@param  backNode        [cc.Node]   背景节点, 可为nil
@param	style			[table]
{
	padding = {}
	thumbSkin = {}, 
	bgSkin = {}, 
	text = {
		normal = {}, 
		selected = {}, 
}
}
]]
function newSlideSwitch(params)
	assert(params and type(params) == "table", "[UI] newSlideSwitch() params must be a unnil table.")

	local finalParams = clone(SLIDE_SWITCH_DEFAULT_PARAMS)
	TableUtil.mergeA2B(params, finalParams)

	local w, h = finalParams.width, finalParams.height

	local itemSize = cc.size(
		(w - finalParams.itemGap - finalParams.style.padding.left - finalParams.style.padding.right) / 2,
		h - finalParams.style.padding.top - finalParams.style.padding.bottom
	)

	local node1 = finalParams.itemTemplate(finalParams.textON, itemSize, finalParams.style.text.normal)
	local node2 = finalParams.itemTemplate(finalParams.textOFF, itemSize, finalParams.style.text.normal)
	node1:setPosition(finalParams.style.padding.left, finalParams.style.padding.bottom)
	node2:setPosition(
		finalParams.style.padding.left + itemSize.width + finalParams.itemGap,
		finalParams.style.padding.bottom
	)

	local bgNode = params.backNode or UI.newScale9Sprite({
		width = w, height = h,
		style = finalParams.style.bgSkin
	})

	local thumbNode = params.slideNode or UI.newScale9Sprite({
		width = itemSize.width,
		height = itemSize.height,
		style = finalParams.style.thumbSkin
	})

	local function onChange(target, isOn)
		if isOn then
			node1:setLabelColor(finalParams.style.text.selected.color)
			node2:setLabelColor(finalParams.style.text.normal.color)
		else
			node1:setLabelColor(finalParams.style.text.normal.color)
			node2:setLabelColor(finalParams.style.text.selected.color)
		end

		if type(params.onChange) == "function" then
			params.onChange(target, isOn)
		end
	end

	local switch = newSlideSwitchNode({
		x = finalParams.x, y = finalParams.y,
		anchorPoint = finalParams.anchorPoint,
		backNode = bgNode,
		slideNode = thumbNode,
		onChange = onChange,
		padding = finalParams.style.padding,
	})
	switch:addChild(node1)
	switch:addChild(node2)


	function switch:setOn(value)
		switch:setLeft(value)
	end

	function switch:isOn()
		return switch:isLeft()
	end

	if finalParams.isOn then
		switch:setOn(true)
		node1:setLabelColor(finalParams.style.text.selected.color)
		node2:setLabelColor(finalParams.style.text.normal.color)
	else
		switch:setOn(false)
		node1:setLabelColor(finalParams.style.text.normal.color)
		node2:setLabelColor(finalParams.style.text.selected.color)
	end

	switch:setAnchorPoint(finalParams.anchorPoint)


	return switch
end
