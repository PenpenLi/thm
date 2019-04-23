module("UI", package.seeall)

ACCORDION_DEFAULT_WIDTH = 300
ACCORDION_DEFAULT_HEIGHT = 600
--默认锚点
ACCORDION_DEFAULT_ANCHOR_POINT = UI.POINT_LEFT_BOTTOM
--默认是否开启动作
ACCORDION_DEFAULT_ACTION_ENABLED = true
--默认两个临近项的间隔
ACCORDION_DEFAULT_GAP = 4
--默认头部高度
ACCORDION_DEFAULT_HEAD_HEIGHT = 56
--默认头部
ACCORDION_DEFAULT_HEAD_TEMPLATE = function(title, w, h, zoomScale, outline, isDrawArrow, imageType, exData,callback)
	local btn = UI.newWidget({
		width = w, height = h,
	})

	local isArrow = isDrawArrow or false
	local imageType = imageType or 1
	local imageNormalName = "win_frame8"
	local imageSelectedName = "win_frame8"
	if 2 == imageType then
		imageNormalName = "win_frame3"
		imageSelectedName = "win_frame_high_3"
	elseif 3 == imageType then
		imageNormalName = "win_frame11"
		imageSelectedName = "win_frame11"
	end

	local selectedBtn = UI.newBaseButton({
		text = title,
		zoomScale = zoomScale,
		style = {
			normal = {
				label = {size = UI.FONT_SIZE_NORMAL, color = UI.getColorHtml("#15233d")},
				skin = {
					src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.WINDOW, imageNormalName),
					scale9Rect = {left = 20, right = 20, top = 20, bottom = 20},
				}
			},
			selected = {
				label = {size = UI.FONT_SIZE_NORMAL, color = UI.getColorHtml("#15233d")},
				skin = {
					src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.WINDOW, imageSelectedName),
					scale9Rect = {left = 20, right = 20, top = 20, bottom = 20}
				}
			},
			disabled = {
				label = {size = UI.FONT_SIZE_NORMAL, color = UI.COLOR_GRAY_C, outline = outline or 1},
				skin = {
					src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.ACCORDION, "accord_disa1"),
					scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
				}
			}
		},
		width = w, height = h
	})
	selectedBtn:setSwallowTouches(false)
	selectedBtn:setPropagateTouchEvents(false)
	btn:addChild(selectedBtn)


	--箭头
	if isArrow then
		local arrow = UI.newImage({
			source = "",--ResManager.getRes(ResType.PUBLIC, "img_arrow"),
			x = w-15,
			y = h / 2,
			anchorPoint = UI.POINT_RIGHT_CENTER
		})
		btn:addChild(arrow, 2, 2)
		arrow:setFlippedY(true)
	end

	if exData and exData.redDotData then
		local redDot = UIPublic.newRedDot(exData.redDotData)
		btn:addChild(redDot)
	end

	function btn:onChange(params)
		if params.isFolded then
			selectedBtn:setNormalNode()
			if isArrow then
				self:getChildByTag(2):setFlippedY(true)
			end
		else
			selectedBtn:setSelectedNode()
			if type(callback) == "function" then 
				callback(self)
			end
			if isArrow then
				self:getChildByTag(2):setFlippedY(false)
			end
		end
	end

	return btn
end

ACCORDION_TEAM_HEAD_TEMPLATE = function(title, w, h, zoomScale, outline)
	local btn = UI.newWidget({
		width = w,
		height = h,
	})

	local function createNode(isNormal)
		local node = UI.newNode()
		local bg = false
		local text = false
		if isNormal then
			bg = UI.newImage({
				x = w / 2,
				y = h / 2,
				style = {
					src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.ACCORDION, "accord_disa1"),
					scale9Rect = {left = 10, right = 10, top = 10, bottom = 10},
				}
			})
			text = UI.newLabel({
				anchorPoint = UI.POINT_CENTER,
				text = title,
				x = w / 2, y = h / 2,
				style = {
					size = UI.FONT_SIZE_BIGGER,
					color = UI.htmlColor2C3b("#d7d6c9"),
					outline = outline or 1
				}
			})
		else
			bg = UI.newImage({
				x = w / 2, y = h / 2,
				style = {
					src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.ACCORDION, "accord_sel1"),
					scale9Rect = {left = 10, right = 10, top = 10, bottom = 10},
				}
			})
			text = UI.newBMFontLabel({
				anchorPoint = UI.POINT_CENTER,
				text = title,
				x = w / 2, y = h / 2,
				style = {
					size = UI.FONT_SIZE_BIGGER,
					font = "",--ResManager.getResSub(ResType.FONT, FontType.FNT, "tap_sel")
				}
			})
		end
		node:addChild(bg)
		node:addChild(text)

		return node
	end

	local selectedBtn = UI.newBaseButton({
		zoomScale = zoomScale,
		normalNode = createNode(true),
		selectedNode = createNode(),
		width = w, height = h
	})
	selectedBtn:setSwallowTouches(false)
	selectedBtn:setPropagateTouchEvents(false)
	btn:addChild(selectedBtn)

	function btn:onChange(params)
		if params.isFolded then
			selectedBtn:setNormalNode()
		else
			selectedBtn:setSelectedNode()
		end
	end

	function btn:isSelected()
		return selectedBtn:isSelected()
	end

	return btn
end


--[[
创建单个显示可折叠的容器

@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		锚点(如THSTG.UI.POINT_CENTER)
@param	onChange		[function]	变更当前选择项时的回调函数，格式如：onChange(node, curPosition, lastPosition)
									node:   accordion节点
									curPosition:  点击的item位置
									lastPositon:   上次点击的item位置，可能为nil

		或head，content节点具有onChange[function({target, isFolded, position})]
@param  gap             [number]   item间的间隔距离

@param style = {[table]   背景皮肤
				bgColor = clone(UI.COLOR_WHITE), 
				bgSkin = clone(UI.TABBAR_DEFAULT_HT_NORMAL_SKIN)
}
]]
function newAccordion(params)
	local function tipLog(str)
	-- print(168,"newAccordion: "..str)
	end

	local finalParam = {
		x = 0,
		y = 0,
		width = UI.ACCORDION_DEFAULT_WIDTH,
		height = UI.ACCORDION_DEFAULT_HEIGHT,
		anchorPoint = clone(UI.ACCORDION_DEFAULT_ANCHOR_POINT),
		gap = UI.ACCORDION_DEFAULT_GAP, --间隔
		isCanCancel = true,
		onChange = function (node, curPosition, lastPosition)

		end,
	-- style={
	-- 	bgColor=false,
	-- 	bgSkin=clone(UI.TABBAR_DEFAULT_HT_NORMAL_SKIN)
	-- }
	}
	TableUtil.mergeA2B(params, finalParam)

	local accordion = UI.newScrollView({
		x = finalParam.x,
		y = finalParam.y,
		width = finalParam.width,
		height = finalParam.height,
		bounceEnabled = true,
		direction = ccui.ScrollViewDir.vertical,
		anchorPoint = finalParam.anchorPoint,
		style = finalParam.style
	})

	local privateData = {}
	privateData.nodeItem = {}     --key: pos,  value: item
	privateData.curItem = nil     --当前展开的item
	privateData.itemChange = 1   --item数量改变
	privateData.stateChange = 2  --状态改变
	privateData.animationTime = 0.3
	privateData.oldPosY = nil
	--------------------------------------------------------------------

	function privateData.init()
		--注册事件
		accordion:registerScriptHandler(privateData.onNodeEvent)
	end

	--[[节点事件]]
	function privateData.onNodeEvent(event)
		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		if event == "enter" then
			privateData.afterUpdateListener = cc.EventListenerCustom:create("director_after_update", privateData.afterUpdate)
			eventDispatcher:addEventListenerWithFixedPriority(privateData.afterUpdateListener, 1)
			-- tipLog("privateData.afterUpdateListener add.")
		elseif event == "exit" then
			eventDispatcher:removeEventListener(privateData.afterUpdateListener)
			privateData.afterUpdateListener = nil
			-- tipLog("privateData.afterUpdateListener removed.")
		end
	end

	--[[判断是否需要更新可见性]]
	function privateData.isDirty()
		local dirty = false

		if not params.isFoldedNoClick then
			return true
		end

		--针对滚动，更新可见性
		local x, y = accordion:getInnerContainer():getPosition()
		if y ~= privateData.oldPosY then
			dirty = true
			privateData.oldPosY = y
		end

		--针对折叠动画
		for i = 1, #privateData.nodeItem do
			local childContent = privateData.nodeItem[i].childContent
			local ix, iy = childContent:getPosition()
			if childContent.__oldY__ ~= iy then
				dirty = true
				childContent.__oldY__ = iy
			end
		end

		return dirty
	end

	--核心函数
	--[[每针更新可见性]]
	function privateData.afterUpdate()
		if  privateData.isDirty() then
			privateData.updateItemVisible()
			--tipLog("afterUpdate")
		end
	end

	--[[修改item触发的动作]]
	function privateData.onItemChange()
		privateData.updateInnerSize()
		privateData.updateItemState()
		privateData.updateItemPos(privateData.itemChange)
		privateData.stopFoldAciton()
	end

	function privateData.positionChange(position)
		local head = accordion:getHead(position)
		local content = accordion:getContent(position)
		if head then
			if head.onChange then
				head:onChange({isFolded = accordion:isFolded(position), target = accordion, position = position})
			end
		end
		if content then
			if content.onChange then
				content:onChange({isFolded = accordion:isFolded(position), target = accordion, position = position})
			end
		end
	end

	function privateData.onChange(curPosition, lastPosition)
		if curPosition then
			privateData.positionChange(curPosition)
		end

		if lastPosition then
			privateData.positionChange(lastPosition)
		end
	end

	function privateData.fold(cur)
		local old = privateData.curItem
		local curPosition = cur.__pos__
		local lastPosition = nil
		cur.__isFolded__ = not cur.__isFolded__
		if cur.__isFolded__ then
			privateData.curItem = nil
		else
			privateData.curItem = cur
		end

		if old and old ~= cur then
			old.__isFolded__ = not old.__isFolded__
			lastPosition = old.__pos__
		end

		privateData.applyFoldAction()
		privateData.onChange(curPosition, lastPosition)

		-- 点击最后一个展开，往上弹
		-- print(5, "击最后一个展开，往上弹", privateData.curItem, curPosition, #privateData.nodeItem)
		if privateData.curItem and curPosition == #privateData.nodeItem then
		-- accordion:scrollToBottom(privateData.animationTime, false)
		end

		if finalParam.onChange then
			finalParam.onChange(accordion, curPosition, lastPosition, cur.__isFolded__, privateData.curItem and privateData.curItem.key)
		end

		--将当前选中的item滚动到显示区域top
		if params.autoScrollSelectedItem then
			local innerHeight=accordion:getContentSize().height
			local scrollViewHeight=accordion:getInnerContainerSize().height
			local selectedNodePosY=privateData.getFinalPos(curPosition)

			-- selectedNodePosY=selectedNodePosY>innerHeight and selectedNodePosY or innerHeight
			local _,innerContentPosY=accordion:getInnerContainer():getPosition()

			local percentHeight=scrollViewHeight-innerHeight

			local percent=100
			if(percentHeight~=0)then
				percent=(scrollViewHeight-selectedNodePosY)/(percentHeight)*100
			end
			accordion:scrollToPercentVertical(percent,1.5,true)
		end
	end

	--[[点击item事件]]
	function privateData.onHeadClick(event)
		--tipLog("onHeadClick: "..tostring(event.name))

		if params.isFoldedNoClick and event.target:getParent() == privateData.curItem then
			-- 选中能否再点
			return
		end

		if not finalParam.isCanCancel and event.target.isSelected and event.target:isSelected() then return end
		if event.name == "ended" then
			privateData.fold(event.target:getParent())
		end
	end

	--[[插入item]]
	function privateData.insertItem(head, content, position, key)
		if position then
			if position <= 0 or position > #privateData.nodeItem then
				tipLog("position invalid: "..tostring(position))
				return
			end
		end

		position = position or (#privateData.nodeItem + 1)
		local anchorPoint = cc.p(0, 0)


		local item = ccui.Widget:create()
		item:setAnchorPoint(cc.p(0, 1))

		local nodeHead = head
		nodeHead:setTouchEnabled(true)
		nodeHead:onTouch(privateData.onHeadClick)
		nodeHead:setAnchorPoint(cc.p(0, 1))
		
		local nodeContent = ccui.Layout:create()
		nodeContent:setClippingType(ccui.ClippingType.SCISSOR)
		nodeContent:setClippingEnabled(true)
		nodeContent:setAnchorPoint(anchorPoint)


		local nodeChildContent = ccui.Layout:create()
		nodeContent:setClippingType(ccui.ClippingType.SCISSOR)
		nodeContent:setClippingEnabled(true)
		nodeChildContent:setAnchorPoint(anchorPoint)
		nodeChildContent:addChild(content)


		nodeContent:addChild(nodeChildContent)
		item:addChild(nodeContent)
		item:addChild(nodeHead)

		item.head = nodeHead
		item.content = nodeContent
		item.childContent = nodeChildContent
		item.realContent = content
		item.key = key or position
		privateData.updateItemLayout(item)

		table.insert(privateData.nodeItem, position, item)
		accordion:addChild(item)
		privateData.onItemChange()
	end

	--[[删除]]
	function privateData.deleteItem(position)
		if position then
			if position <= 0 or position > #privateData.nodeItem then
				tipLog("position invalid: "..tostring(position))
				return
			end
		end

		local item = privateData.nodeItem[position]
		accordion:removeChild(item)
		if privateData.curItem == item then
			privateData.curItem = nil
		end
		table.remove(privateData.nodeItem, position)
		privateData.onItemChange()
		--set dirty
		privateData.oldPosY = nil
	end

	function privateData.deleteAllItem()
		for i = 1, (#privateData.nodeItem) do
			local item = privateData.nodeItem[i]
			accordion:removeChild(item)
		end
		privateData.nodeItem = {}
		privateData.onItemChange()
		privateData.oldPosY = nil
		privateData.curItem = nil
	end

	--停止动画
	function privateData.stopFoldAciton()
		for i, v in ipairs(privateData.nodeItem) do
			v:stopAllActions()
			local vx, vy = v:getPosition()
			vy = privateData.getFinalPos(i)
			v:setPosition(cc.p(vx, vy))

			v.childContent:stopAllActions()
			local cx, cy = v.childContent:getPosition()
			if v.__isFolded__ then
				cy = v.content:getContentSize().height
				v.content:setVisible(false)
			else
				cy = 0
				v.content:setVisible(true)
				tipLog("stopFoldAciton content true: "..tostring(i))
			end
			v.childContent:setPosition(cc.p(cx, cy))
		end
	end

	--[[展开或折叠动作]]
	function privateData.applyFoldAction()
		local changeLen = privateData.updateInnerSize()
		privateData.updateItemPos(privateData.stateChange, changeLen)

		local time = privateData.animationTime
		local rate = 1
		for i, v in ipairs(privateData.nodeItem) do
			v:stopAllActions()
			local desp = privateData.getFinalPos(i)
			local curpx, curpy = v:getPosition()
			if desp ~= curpy then
				local moveTo = cc.MoveTo:create(time, cc.p(curpx, desp))
				local easeAction = cc.EaseIn:create(moveTo, rate)
				v:runAction(easeAction)
			end

			local cx, cy = v.childContent:getPosition()
			local cdes = cy
			if v.__isFolded__ then
				cdes = v.content:getContentSize().height
			else
				cdes = 0
			end
			v.childContent:stopAllActions()

			local moveTo = cc.MoveTo:create(time, cc.p(cx, cdes))
			local onComplete = function ()
				v:setVisible(true)
				if v.__isFolded__ then
					v.content:setVisible(false)
					tipLog("contentActionEnd content false")
				else
					tipLog("content content not isFolded")
				end
				v.content:setPosition(v.content:getPosition())
				-- dump(5, v.childContent:getContentSize(), "v.childContent")
			end
			-- v.childContent:setVisible(false)
			-- v.childContent:runAction(transition.create(moveTo, {onComplete = onComplete, easing = true}))
			v.childContent:runAction(transition.create(moveTo, {onComplete = onComplete, easing = true}))
		end
	end

	--[[每次更新计算item的最终位置]]
	function privateData.getFinalPos(position)
		local h = 0
		for i = 1, position - 1 do
			local preItem = privateData.nodeItem[i]
			if preItem then
				h = h + privateData.getStepLength(preItem)
			end
		end
		local totalH = accordion:getInnerContainerSize().height
		return totalH - h
	end

	---------------------------------------------------------------------

	--[[重新排列item的节点位置]]
	function privateData.updateItemLayout(item)
		local headSize = item.head:getContentSize()
		local contentSize = item.realContent:getContentSize()

		item.head:setContentSize(headSize)
		item.content:setContentSize(contentSize)
		item:setContentSize(cc.size(headSize.width, headSize.height + contentSize.height))

		item.head:setPosition(cc.p(0, headSize.height + contentSize.height))
		item.childContent:setPosition(cc.p(0, 0))
		item.content:setPosition(cc.p(0, 0))

		item.childContent:setContentSize(contentSize)

		local contAr = item.realContent:getAnchorPoint()
		item.realContent:setPosition(cc.p(contAr.x * contentSize.width, contAr.y * contentSize.height))
		-- item.realContent:setPosition(0, 0)

	end

	--[[更新总长]]
	function privateData.updateInnerSize()
		local curH = 0
		for _, item in ipairs(privateData.nodeItem) do
			curH = curH + privateData.getStepLength(item)
		end
		local size = accordion:getInnerContainerSize()
		local old = size.height

		size.height = curH
		accordion:setInnerContainerSize(size)

		return accordion:getInnerContainerSize().height - old
	end

	--[[更新内容节点的可见性， 有利于提高效率]]
	function privateData.updateItemVisible()
		local miny, maxy = privateData.getViewPosRange()
		for i, item in ipairs(privateData.nodeItem) do
			-- 不知道有什么用
			local content = item.content
			local childContent = item.childContent
			local x, y = childContent:getPosition()
			if y >= content:getContentSize().height then
				content:setVisible(false)
			else
				content:setVisible(true)
				tipLog("position true: "..tostring(i).." y: "..tostring(y).." height: "..tostring(content:getContentSize().height)..tostring("isFolded:")..tostring(item.__isFolded__))
			end
			local rx, ry = item:getPosition()
			local lb = ry
			if item.__isFolded__ then
				lb = ry - item.head:getContentSize().height
			else
				lb = ry - item:getContentSize().height
			end
			if ry > miny and (lb) < maxy then
				item:setVisible(true)
				tipLog("item position true: "..tostring(i))
			else
				item:setVisible(false)
			end
		end
		local x, y = accordion:getInnerContainer():getPosition()
		privateData.oldPosY = y
	end

	--[[获取当前item到xiayiitem的距离]]
	function privateData.getStepLength(item)
		if item ~= privateData.curItem then
			return finalParam.gap + item.head:getContentSize().height
		else
			return finalParam.gap + item:getContentSize().height
		end
	end

	--[[更新item状态]]
	function privateData.updateItemState()
		for i, v in ipairs(privateData.nodeItem) do
			v.__pos__ = i
			v:getParent():reorderChild(v, i)
			if v ~= privateData.curItem then
				v.__isFolded__ = true
			else
				v.__isFolded__ = false
			end
		end
	end
	--[[更新位置]]
	function privateData.updateItemPos(ty, params)
		if ty == privateData.itemChange then
			local h = 0
			local innerSize = accordion:getInnerContainerSize()
			for i, v in ipairs(privateData.nodeItem) do
				local y = innerSize.height - h
				v:setPosition(cc.p(0, y))
				h = h + privateData.getStepLength(v)
			end
		elseif ty == privateData.stateChange then
			for i, v in ipairs(privateData.nodeItem) do
				local x, y = v:getPosition()
				v:setPosition(cc.p(0, y + params))
			end
		end


	end
	--[[设置对应item的内容大小]]
	function privateData.setContentLen(position, len)
		local item = privateData.nodeItem[position]
		if item then
			local items = item:getContentSize()
			local hs = item.head:getContentSize()
			local cs = item.content:getContentSize()

			cs.height = len
			cs.height = math.max(0, cs.height)
			items.height = cs.height + hs.height
			item.content:setContentSize(cs)
			item.realContent:setContentSize(cs)
			item:setContentSize(items)
			privateData.updateItemLayout(item)

			privateData.applyFoldAction()
		end
	end

	--[[获取可视区域y范围，相对innernode]]
	function privateData.getViewPosRange()
		local innerx, innery = accordion:getInnerContainer():getPosition()
		local miny, maxy = 0, accordion:getContentSize().height
		local innerMiny, innerMaxy = (0 - innery), (maxy - innery)
		return innerMiny, innerMaxy
	end

	---------------------------------------------------------------------
	---外部接口
	--[[获取具体位置的item是否折叠情况
	position 	[number]	item的位置, 1到getItemNum()
	]]
	function accordion:isFolded(position)
		local item = privateData.nodeItem[position]
		if item then
			return item.__isFolded__
		else
			tipLog("accordion:isFolded position invalid"..tostring(position))
		end

		return false
	end

	--[[获取按钮节点
	--position: [number] item 的位置
	]]
	function accordion:getHead(position)
		local item = privateData.nodeItem[position]
		if item then
			return item.head
		else
			tipLog("accordion:isFolded position invalid"..tostring(position))
		end
	end

	--[[获取内容节点
	--position: [number] item 的位置
	]]
	function accordion:getContent(position)
		local item = privateData.nodeItem[position]
		if item then
			return item.realContent
		else
			tipLog("accordion:isFolded position invalid"..tostring(position))
		end
	end

	--[[设置内容长度
	--position: [number] item 的位置
	--len:		[number] 内容长度
	]]
	function accordion:setContentLen(position, len)
		privateData.setContentLen(position, len)
	end

	--[[插入item， 程序会通过head,content的getContentSize()方法获取对应的长度和宽度
	--head：   [wegit]   头节点
	--conten   [wegit]   内容节点
	--position: 1 到 getItemNum() 或 nil(插入到末尾)
	]]
	function accordion:insertItem(head, content, position, key)
		privateData.insertItem(head, content, position, key)
	end

	--[[删除]]
	function accordion:deleteItem(position)
		privateData.deleteItem(position)
	end
	function accordion:deleteAllItem()
		privateData.deleteAllItem()
	end

	--[[获取item数量]]
	function accordion:getItemNum()
		return #privateData.nodeItem
	end

	function accordion:setSelectedIndex(index, animated)
		if type(index) == "string" then
			for i, v in ipairs(privateData.nodeItem) do
				if v.key == index then
					index = i
					break
				end
			end
			if type(index) ~= "number" then
				return
			end
		else
			assert(0 < index and index <= #privateData.nodeItem, "index is illegal")
		end
		if not finalParam.inCanCancel and accordion:getSelectedIndex() == index then return end
		privateData.fold(privateData.nodeItem[index])
		if not animated then
			privateData.stopFoldAciton()
		end
	end

	function accordion:getSelectedIndex()
		if privateData.curItem then
			return privateData.curItem.__pos__
		end
	end

	function accordion:getSelectedHead()
		if privateData.curItem then
			return privateData.curItem.head
		end
	end

	function accordion:getSelectedContent()
		if privateData.curItem then
			return privateData.curItem.realContent
		end
	end

	function accordion:scrolltoBottom(ignore)
		if ignore == true or accordion:getSelectedIndex() == #privateData.nodeItem then
			accordion:scrollToBottom(privateData.animationTime, false)
		end
	end

	---------------------------------------------------------------------
	function accordion:foldSelectedIndex( index )
		privateData.fold(privateData.nodeItem[index])
		privateData.stopFoldAciton()
	end

	privateData.init()

	return accordion
end
