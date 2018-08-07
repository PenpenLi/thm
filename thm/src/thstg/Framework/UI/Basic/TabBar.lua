module("THSTG.UI", package.seeall)

--横向处于界面上方
TABBAR_DIRECTION_HT = 1
--横向处于界面下方
TABBAR_DIRECTION_HB = 2
--纵向处于界面左方
TABBAR_DIRECTION_VL = 3
--纵向处于界面右方
TABBAR_DIRECTION_VR = 4

--横向布局上方的标签栏皮肤样式
TABBAR_DEFAULT_HT_NORMAL_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_HT_SELECTED_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_HT_DISABLED_SKIN = {
	src = "",
	sscale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}

--横向布局下方的三个默认皮肤
TABBAR_DEFAULT_HB_NORMAL_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_HB_SELECTED_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_HB_DISABLED_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
--纵向处于界面左方的三个默认皮肤
TABBAR_DEFAULT_VL_NORMAL_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_VL_SELECTED_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}
TABBAR_DEFAULT_VL_DISABLED_SKIN = {
	src = "",
	scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
}


local function newTabbarTextStyle(params)
	params = params or {}
	local style = newTextStyle(params)
	style.artFont = params.artFont or false
	style.artWidth = params.artWidth or false
	style.artHeight = params.artHeight or  false
	return style
end

TABBAR_DEFAULT_PARAMS = {
	x = 0, 
	y = 0,
	anchorPoint = clone(POINT_CENTER),
	direction = TABBAR_DIRECTION_HT,
	itemGap = 5,
	paddingX = 15,
	paddingY = 5,
	selectedIndex = 1,
	isBMFontLabel = false,
	widthGap = 0,
	style = {
		normal = {
			label = newTabbarTextStyle(),
		},
		pressed = {
			label = newTabbarTextStyle()
		},
		disabled = {
			label = newTabbarTextStyle({color = COLOR_GRAY_C, })
		},
	},
}

--获取按钮最终尺寸
local function getFinalSize(size1, size2, paddingX, paddingY)
	local finalSize = cc.size(0, 0)
	if size1.width > size2.width then
		local gapX = (size1.width - size2.width) / 2
		if gapX >= paddingX then
			finalSize.width = size1.width
		else
			finalSize.width = size2.width + paddingX * 2
		end
	else
		finalSize.width = size2.width + paddingX * 2
	end
	if size1.height > size2.height then
		local gapY = (size1.height - size2.height) / 2
		if gapY >= paddingY then
			finalSize.height = size1.height
		else
			finalSize.height = size2.height + paddingY * 2
		end
	else
		finalSize.height = size2.height + paddingY * 2
	end
	return finalSize
end
--[[
创建tabBar

params中可用参数：
@param	direction			设置位置各开口朝向，取值[TABBAR_DIRECTION_HT, TABBAR_DIRECTION_HB, TABBAR_DIRECTION_VL, TABBAR_DIRECTION_VR]
@param  tabBarKey           每一项的关键字索引
@param	dataProvider		数据源
{
	"Label1", 
	"Label2", 
	"Label3", 
}
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param	width		[number]	宽度， 可视区域宽度，垂直排列时失效
@param	height		[number]	高度, 可视区域高度，水平排列时失效
@param  itemWidth   [number]    item的宽度  
@param  itemHeight   [number]    item的高度
@param	anchorPoint	[cc.p]	锚点(如UI.POINT_CENTER)
@param	itemGap		[number]	按钮间的间隔
@param	selectedIndex	[number]	创建时选中的标签页，默认为1
@param	ignoreAutoSelect
@param	onSelectedClick	[function]	再次点击选中按钮的回调，传入索引
@param	onChange	[function]	变更选择项时的回调，回调函数的格式如：function callback(params) end，
								其中params格式如：{currentIndex:当前选中项的索引[1-N], lastIndex = 变更前选择的页[1-N], tag = 对应TabBar的tag}
@param  barNode      [table]    
				{
							 normalNode   [cc.Node]   正常状态下的节点
							 selectedNode [cc.Node]  选择状态下的节点
							 disabledNode [cc.Node]  不可按状态下的节点
							 sharedNode   [cc.Node]   共享节点, 类似标签上的文本节点
}

@param	style		[table]		按钮和ArtLabel文本样式
{
	normal = {
		label = {}, 
		skin = {}, 
}, 
	pressed = {
		label = {}, 
		skin = {}, 
}
	disabled = {}, 

	--艺术字参数
	artFont = ResManager.getResSub(ResType.FONT, FontType.FNT, "arial")  --艺术字, 默认为nil
}

按钮皮肤样式，详细写法参考Button的style

@return	返回FRTabBar对象

@example
]]

function newTabBar(params)
	assert(type(params) == "table", "[UI] newTabBar() invalid params")
	assert(params.dataProvider ~= nil, "TabBar required LayerStack as param, params.dataProvider required")

	local function tipLog(str)
		print("newTabBar2: "..str)
	end

	local finalParams = clone(TABBAR_DEFAULT_PARAMS)
	
	if params.direction == TABBAR_DIRECTION_HB then
		finalParams.style.normal.skin = clone(TABBAR_DEFAULT_HB_NORMAL_SKIN)
		finalParams.style.pressed.skin = clone(TABBAR_DEFAULT_HB_SELECTED_SKIN)
		finalParams.style.disabled.skin = clone(TABBAR_DEFAULT_HB_DISABLED_SKIN)

	elseif params.direction == TABBAR_DIRECTION_VL then
		finalParams.style.normal.skin = clone(TABBAR_DEFAULT_VL_NORMAL_SKIN)
		finalParams.style.pressed.skin = clone(TABBAR_DEFAULT_VL_SELECTED_SKIN)
		finalParams.style.disabled.skin = clone(TABBAR_DEFAULT_VL_DISABLED_SKIN)

	elseif params.direction == TABBAR_DIRECTION_VR then
		finalParams.style.normal.skin = clone(TABBAR_DEFAULT_VL_NORMAL_SKIN)
		finalParams.style.pressed.skin = clone(TABBAR_DEFAULT_VL_SELECTED_SKIN)
		finalParams.style.disabled.skin = clone(TABBAR_DEFAULT_VL_DISABLED_SKIN)

	else
		finalParams.style.normal.skin = finalParams.style.normal.skin or clone(TABBAR_DEFAULT_HT_NORMAL_SKIN)
		finalParams.style.pressed.skin = finalParams.style.pressed.skin or clone(TABBAR_DEFAULT_HT_SELECTED_SKIN)
		finalParams.style.disabled.skin = finalParams.style.disabled.skin or clone(TABBAR_DEFAULT_HT_DISABLED_SKIN)
	end

	TableUtil.mergeA2B(params, finalParams)

	local paramsStyle = clone(params.style) or {}
	paramsStyle.normal = paramsStyle.normal or {}
	paramsStyle.pressed = paramsStyle.pressed or {}
	paramsStyle.disabled = paramsStyle.disabled or {}
	if paramsStyle.normal.label then
		finalParams.style.pressed.label = paramsStyle.pressed.label or paramsStyle.normal.label
		finalParams.style.disabled.label = paramsStyle.disabled.label or paramsStyle.normal.label
	end

	-- dump(5, finalParams)

	local menu = ccui.ListView:create()

	local privateData = {}

	local curSelectedItem = nil
	local curIndex = nil

	local isH = true
	local menuH = 0
	local menuW = 0
	local function createtabBarNode(index)

		--[[
		例子：
		@params iconOffset  [number]  图标偏移
		@params nameOffset  [number]  文本偏移
		label
		@params style   [table]
				{
					selected
					normal
					label
		}
		]]

		local style = params.style or {}
		style.pressed = style.pressed or {}
		style.pressed.skin = style.pressed.skin or {}
		style.pressed.label = style.pressed.label or nil
		style.normal = style.normal or {}
		style.normal.skin = style.normal.skin or {}
		style.normal.label = style.normal.label or nil

		local function createNode(normal)

			local src = params.tabBarSrc and params.tabBarSrc[index] or {}

			local backSrc, scale9Rect

			if normal then
				backSrc = params.tabBarStyle[index].normal.skin.src or style.normal.src or style.normal.skin.src or ResManager.getUIRes(UIType.TAB_BAR, "tab_base_normal")
				scale9Rect = style.normal.scale9Rect or style.normal.skin.scale9Rect or {left = 7, right = 7, top = 5, bottom = 5}
			else
				backSrc = params.tabBarStyle[index].pressed.skin.src or style.pressed.src or style.pressed.skin.src or ResManager.getUIRes(UIType.TAB_BAR, "tab_base_sel")
				scale9Rect = style.pressed.scale9Rect or style.pressed.skin.scale9Rect or {left = 7, right = 7, top = 5, bottom = 5}
			end

			local root = newNode({})
			-- local root = newWidget({
			-- 	onClick=function( ... )
			-- 		print(77,"i am widget")
			-- 	end
			-- })

			local back = newImage({
				width = params.itemWidth,
				height = params.itemHeight,
				style = {
					src = backSrc,
					scale9Rect = scale9Rect,
				},
				anchorPoint = POINT_LEFT_BOTTOM,
				-- onClick=function ( ... )
				-- 	print(77,"i am image~~~")
				-- end
			})
			root:addChild(back)
			if(params.tabBarStyle[index].isFlippedX)then
				back:setPositionX(back:getContentSize().width)
				back:setFlippedX(true)
			end

			local backSize = back:getContentSize()
			root:setContentSize(backSize)

			local contentY = backSize.height / 2

			local namePosX = params.namePosX or (backSize.width / 2 - 3)
			local nameLength = StringUtil.getLength(src.name)
			local name
			if normal then
				local additionalKerning = 20
				if nameLength >= 4 then
					additionalKerning = 0
				elseif nameLength >= 3 then
					additionalKerning = 6
				end

				if finalParams.isBMFontLabel then
					name = newBMFontLabel({
						text = src.name,
						x = namePosX,
						y = contentY - 5,
						anchorPoint = POINT_CENTER,
						style = style.label or style.normal.label,
					})
				else
					name = newLabel({
						text = src.name,
						x = namePosX,
						y = contentY,
						anchorPoint = POINT_CENTER,
						style = style.normal.label or {
							size = FONT_SIZE_BIG,
							color = getColorHtml("#31315e"),
							additionalKerning = additionalKerning,
						},
					})
				end
				root:addChild(name)
			else
				local additionalKerning = 22
				if nameLength >= 4 then
					additionalKerning = 0
				elseif nameLength >= 3 then
					additionalKerning = 6
				end

				if finalParams.isBMFontLabel then
					name = newBMFontLabel({
						text = src.name,
						x = namePosX,
						y = contentY - 5,
						anchorPoint = POINT_CENTER,
						style = style.label or style.pressed.label,
					})
				else
					name = newLabel({
						text = src.name,
						x = namePosX,
						y = contentY,
						anchorPoint = POINT_CENTER,
						style = style.pressed.label or {
							size = FONT_SIZE_BIG,
							color = getColorHtml("#6c3e26"),
							outline = 1,
							outlineColor = getColorHtml("#f0e6a9"),
							additionalKerning = additionalKerning,
						},
					})
				end
				root:addChild(name)
			end

			if type(src.getCustomNode) == "function" then
				local customNode = src:getCustomNode(root)
				if customNode then
					root:addChild(customNode)
				end
			end

			function root:getLabel()
				return name
			end

			return root
		end
		return {normalNode = createNode(true), selectedNode = createNode()}
	end


	local function newTabItem(itemParams)
		local style = params.style or {}

		params.tabBarStyle = params.tabBarStyle or {}
		params.tabBarStyle[itemParams.index] = params.tabBarStyle[itemParams.index] or {}
		local tabBarStyle=params.tabBarStyle[itemParams.index]
		tabBarStyle = tabBarStyle or {}
		tabBarStyle.normal = tabBarStyle.normal or {}
		tabBarStyle.pressed = tabBarStyle.pressed or {}
		tabBarStyle.normal.skin = tabBarStyle.normal.skin or {}
		tabBarStyle.pressed.skin = tabBarStyle.pressed.skin or {}

		local curNode = {}
		local barNode = params.barNode or {}
		if params.createBarNode then
			curNode = createtabBarNode(itemParams.index)
		else
			curNode = barNode[itemParams.index] or {}
		end

		local container = false

		local textOffsetX = params.tabBarStyle[itemParams.index].textOffsetX or style.x
		local item = newSelectedButton({
			width = params.itemWidth,
			height = params.itemHeight,
			hitLen = params.tabBarForceHeight,

			playSound = false,
			onChange = function (event)
				if event.value then
					if event.isClick and params.isPlaySound and curSelectedItem ~= event.container then
						SoundManager.playSound("button")
					end
					menu:setSelectedIndex(menu:getIndex(container) + 1)
				end
			end,
			onSelectedClick = function (target)
				if params.onSelectedClick then
					local index = menu:getIndex(container) + 1
					params.onSelectedClick(index)
				end
			end,
			onUnSelectedClick = function (target)
				if params.onUnSelectedClick then
					local index = menu:getIndex(container) + 1
					params.onUnSelectedClick(index)
				end
			end,
			text = itemParams.text,
			style = {
				x = textOffsetX, 
				y = style.y,
				normal = clone(finalParams.style.normal),
				selected = clone(finalParams.style.pressed),
				disabled = clone(finalParams.style.disabled),
			},
			normalNode = curNode.normalNode,
			selectedNode = curNode.selectedNode,
			disabledNode = curNode.disabledNode,
			sharedNode = curNode.sharedNode,
		})

		--扩大button点击区域
		if(params.tabBarForceHeight)then
			setHitFactor(item,params.tabBarForceHeight)
		end
		-- debugUI(item)

		-- 容器包裹，方便新手指引
		local size = item:getContentSize()
		container = newWidget{
			width = size.width,
			height = size.height,
		}
		container:addChild(item)

		function container:getButton()
			return item
		end

		local src = params.tabBarSrc and params.tabBarSrc[itemParams.index] or {}

		if src.redDotData then
			local redDotData = clone(src.redDotData)
			redDotData.isTab = true
			if redDotData.isCircleOrDot == nil then
				redDotData.isCircleOrDot = true
			end
			local redDot = UIPublic.newRedDot(redDotData)
			item:addChild(redDot,1000)

			if params.redDotPos then
				redDot:setPosition(src.redDotPos or params.redDotPos)
			end
		end

		return container
	end

	function privateData.init()
		
		if params.direction == TABBAR_DIRECTION_VL 
			or params.direction == TABBAR_DIRECTION_VR 
		then
			-- 垂直
			menu:setDirection(ccui.ScrollViewDir.vertical)
			isH = false
		else
			-- 水平
			menu:setDirection(ccui.ScrollViewDir.horizontal)
		end
		
		for k, v in ipairs(params.dataProvider) do

			local vType = type(v)
			if vType == "table" then

			else
				privateData.addItem(tostring(v), k)
			end
		end
		privateData.updateMenu()
	end

	function privateData.addItem(text, index)

		local item = newTabItem({text = text, index = index})
		local finalSize = privateData.updateContentSize(item)
		if isH then
			menuH = math.max(menuH, finalSize.height)
			menuW = menuW + (finalSize.width + finalParams.itemGap)
		else
			menuW = math.max(menuW, finalSize.width + finalParams.widthGap)
			menuH = menuH + (finalSize.height + finalParams.itemGap)
		end
		item.tabBarItemKey = type(params.tabBarKey) == "table" and params.tabBarKey[index] or index
		menu:pushBackCustomItem(item)
	end

	function privateData.updateMenu()
		menu:setItemsMargin(finalParams.itemGap)
		if not params.ignoreAutoSelect then
			menu:setSelectedIndex(finalParams.selectedIndex, true)
		end
		menu:setPosition(finalParams.x, finalParams.y)
		menu:setAnchorPoint(finalParams.anchorPoint)

		menu:setInnerContainerSize(cc.size(menuW, menuH))
		if isH then
			menuW = params.width or menuW
			menuH = params.tabBarForceHeight or menuH
		else
			-- print(77,"params.tabBarHeight =",params.tabBarHeight )
			menuW = menuW
			menuH = params.tabBarHeight or menuH
		end
		-- dump(77,cc.size(menuW, menuH))

		menu:setContentSize(cc.size(menuW, menuH))
		privateData.updateItemPropagate()
	end

	function privateData.updateItemPropagate()
		local menuSize = menu:getContentSize()
		local innerSize = menu:getInnerContainerSize()
		local propagate = false
		if menu:getDirection() == ccui.ScrollViewDir.vertical then
			if innerSize.height > menuSize.height then
				propagate = true
			end
		else
			if innerSize.width > menuSize.width then
				propagate = true
			end
		end
		local items = menu:getItems()
		for k, v in pairs(items) do
			v:setPropagateTouchEvents(propagate)
		end
	end
	function privateData.updateContentSize(item)
		return item:getContentSize()
	end

	function privateData.scrollToIndex(curSelectedIndex)
		if ccui.ScrollViewDir.vertical == menu:getDirection() then
			local holeSize = menu:getInnerContainerSize().height
			local visibleSize = menu:getContentSize().height
			local scrollableSize = holeSize - visibleSize

			if scrollableSize > 0 then
				local itemSize = holeSize / #menu:getItems()
				local targetTopPos = (curSelectedIndex - 1) * itemSize
				local targetBottomPos = targetTopPos + itemSize - visibleSize
				local currentPos = scrollableSize + menu:getInnerContainerPosition().y

				if targetTopPos < currentPos then
					-- scroll to top
					local percent = targetTopPos / scrollableSize * 100
					menu:scrollToPercentVertical(percent, 0, true)

				elseif targetBottomPos > currentPos then
					-- scroll to bottom
					local percent = targetBottomPos / scrollableSize * 100
					menu:scrollToPercentVertical(percent, 0, false)
				end
			end
		else
		-- 水平方向暂不提供
		end
	end

	function privateData.updateItemState(clickItem, curSelectedIndex, forceUpdate)
		if curSelectedItem ~= clickItem then
			local prevSelectedIndex = nil

			if tolua.cast(curSelectedItem, "cc.Node") then
				prevSelectedIndex = menu:getIndex(curSelectedItem) + 1
				curSelectedItem:getButton():setSelected(false)
				tipLog("unselected")
				curSelectedItem = nil
			end

			curSelectedItem = clickItem
			clickItem:getButton():setSelected(true)

			privateData.scrollToIndex(curSelectedIndex)

			if type(params.onChange) == "function" then
				params.onChange(menu, curSelectedIndex, prevSelectedIndex, curSelectedItem.tabBarItemKey)
				printStack(params.onChange)
			end

		elseif forceUpdate then
			params.onChange(menu, curSelectedIndex, nil, curSelectedItem.tabBarItemKey)
		end
		curIndex = curSelectedIndex
	end

	--更新当前选中的Tab索引，从1-N
	function menu:setSelectedIndex(value, forceUpdate)
		if type(value) == "string" then
			menu:setSelectedIndexByKey(value, forceUpdate)
			return
		end
		local item = menu:getItem(value - 1)
		if item then
			privateData.updateItemState(item, value, forceUpdate)
		else
			tipLog("setSelectedIndex value invalid.")
		end
	end

	function menu:getSelectedIndex(...)
		if not tolua.isnull(curSelectedItem) then
			return menu:getIndex(curSelectedItem) + 1
		end
		return nil
	end
	privateData.init()

	-- cocos2 3.81后默认带有scrollbar
	menu:setScrollBarEnabled(false)


	function menu:addItem(index)

		-- 必须有params.tabBarKey
		if params.tabBarKey[index] == nil then
			-- return
		end
		privateData.addItem("", index)
		privateData.updateMenu()
	end

	function menu:removeItemByIndex(index, defaultIndex)
		index = tonumber(index)
		if index and 1 <= index and index <= #(menu:getItems()) then
			menu:removeItem(index - 1)
			menu:setSelectedIndex(defaultIndex or 1, true)
		end
	end

	function menu:removeSelectedIndex(defaultIndex)
		menu:removeItemByIndex(menu:getSelectedIndex(), defaultIndex)
	end

	function menu:setSelectedIndexByKey(key, forceUpdate)
		if not key then return end
		local items = menu:getItems()
		for k1, v1 in ipairs(items) do
			if v1.tabBarItemKey == key then
				menu:setSelectedIndex(k1, forceUpdate)
				return
			end
		end
	end

	function menu:getNode(key)
		local items = menu:getItems()
		for k1, v1 in ipairs(items) do
			if v1.tabBarItemKey == key then
				return v1
			end
		end
	end

	function menu:selectTabWithRedPointFirst()
		--选中第一个带红点的tarBar
		local index = 1
		for k, v in ipairs(params.tabBarSrc) do
			local redDotData = v.redDotData or {}
			local status = Cache.redDotCache.getStatus(redDotData)
			if status then
				index = k
				break
			end
		end
		menu:setSelectedIndex(index, true)
	end

	return menu
end
