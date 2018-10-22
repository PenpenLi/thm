module("UI", package.seeall)

--页标点正常状态资源
PAGE_VIEW_PAGE_POINT_NORMAL_SKIN_SRC = ""--ResManager.getUIRes(UIType.PAGE_VIEW, "page_point_normal")
--页标点选中状态资源
PAGE_VIEW_PAGE_POINT_SELECTED_SKIN_SRC = ""--ResManager.getUIRes(UIType.PAGE_VIEW, "page_point_selected")
--默认宽度
PAGE_VIEW_DEFAULT_WIDTH = 300
--默认高度
PAGE_VIEW_DEFAULT_HEIGHT = 300



local function createPagePoints(params)
	local node = newNode()
	node:setVisible(params.showPagePoint)

	--保存页码点尺寸
	local _pointSize = nil
	local _curIndex = -1

	local _pointPositionDirty = false
	local _curIndexDirty = false

	--默认创建未选中点
	local function createPoint()
		local sp = cc.Sprite:create(params.style.pagePoint.normalSkinSrc)
		sp:setAnchorPoint(POINT_CENTER_BOTTOM)
		sp.selected = false
		return sp
	end

	--更新每个点的位置
	local function undirtyPointPosition()
		_pointPositionDirty = false

		local children = node:getChildren()
		local numChildren = #children
		for k, v in ipairs(children) do
			if not _pointSize then
				_pointSize = v:getContentSize().width
			end
			local x = (2 * k-1-numChildren) * (_pointSize + params.style.pagePoint.gap) / 2
			v:setPositionX(x)
		end
	end

	--更新当前选中的索引
	local function undirtyCurIndex()
		_curIndexDirty = false

		local children = node:getChildren()
		print(168, "undirtyCurIndex", _curIndex)
		for k, v in ipairs(children) do
			if k ~= _curIndex then
				if v.selected then
					v.selected = false
					v:setTexture(params.style.pagePoint.normalSkinSrc)
				end
			else
				if not v.selected then
					v.selected = true
					v:setTexture(params.style.pagePoint.selectedSkinSrc)
				end
			end
		end
	end

	--更新点位置
	local function onFrameUpdate()
		if _pointPositionDirty then
			undirtyPointPosition()
		end
		if _curIndexDirty then
			undirtyCurIndex()
		end
	end
	node:scheduleUpdateWithPriorityLua(onFrameUpdate, 0)

	--加点
	function node:addPoint()
		local point = createPoint(false)
		self:addChild(point)
		_pointPositionDirty = true
	end

	--删除指定索引位置点
	function node:removePointAtIndex(index)
		local children = self:getChildren()
		local point = children[index]
		if point then
			point:removeFromParent(true)
			-- print(1, "~~~~~222~~~~~~point removePointAtIndex", index)
			--如果选中的是最后一个并且要求删除它
			if _curIndex >= #children then
				_curIndex = _curIndex - 1
			end
			_pointPositionDirty = true
			_curIndexDirty = true
		end
	end

	--删除所有点
	function node:removeAllPoints()
		self:removeAllChildren()

		_curIndex = -1
	end

	--更改当前选中的点
	function node:setSelectedIndex(index)
		if _curIndex ~= index then
			_curIndex = index
			_curIndexDirty = true
		end
		-- print(1, "~~~~~333~~~~~nowPage:", index)
	end

	return node
end

--[[
创建PageView
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	showPagePoint	[boolean]	是否显示页码标识，默认为true
@param	numPages		[int]		总页数
@param	defaultPage		[int]		创建时显示在第几页，默认为1，取值[1-N]
@param	scrollThreshold	[false, number]		默认false，为false时使用默认翻页阀值（宽度的一半），为数值时表示像素值
@param	style			[table]		样式
{
	pagePoint = {
		selectedSkinSrc = "a.png", [string]	选中页标资源路径
		normalSkinSrc = "b.png", [string]	未选中页标资源路径
		gap = 8, [number]	页标间隔
		offsetY = 30					[number]	页标栏y坐标偏离值
}
}
@param	onChange	[function]	变更页码时的回调，回调函数的格式如：function callback(event) end，
									其中event格式如：{currentPage:当前页[1-N], lastPage = 变更前选择的页[1-N], tag = 对应TileList的tag}
]]
function newPageView(params)
	assert(params ~= nil, "PageView params is required!")
	-- assert(params.dataList ~= nil, "PageView params.dataList is required!")

	local finalParams = {
		x = 0, y = 0,
		width = 0, height = 0,
		anchorPoint = clone(POINT_LEFT_BOTTOM),
		showPagePoint = true,
		numPages = 1,
		defaultPage = 1,
		scrollThreshold = false,
		style = {
			bgColor = false,
			pagePoint = {
				gap = 10,
				offsetX = 0,
				offsetY = 0,
				normalSkinSrc = PAGE_VIEW_PAGE_POINT_NORMAL_SKIN_SRC,
				selectedSkinSrc = PAGE_VIEW_PAGE_POINT_SELECTED_SKIN_SRC,
			}
		}
	}
	TableUtil.mergeA2B(params, finalParams)


	--总页数
	local _numPages = 0
	--上一次所处的页，用于优化翻页事件处理
	local _prevPage = 0


	local node = newNode()

	--翻页容器
	local pageView = ccui.PageView:create()
	if type(finalParams.style.bgColor) ~= "boolean" then
		pageView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		pageView:setBackGroundColor(finalParams.style.bgColor)
	end
	node:addChild(pageView)

	--页码容器
	local pointContainer = createPagePoints(finalParams)
	node:addChild(pointContainer)


	--覆盖重写原node的接口
	local __setContentSize = pageView.setContentSize
	function node:setContentSize(value)
		__setContentSize(self, value)
		pageView:setContentSize(value)
		pointContainer:setPosition(value.width / 2 + finalParams.style.pagePoint.offsetX, finalParams.style.pagePoint.offsetY)
	end
	node:setAnchorPoint(finalParams.anchorPoint)
	node:setContentSize(cc.size(finalParams.width, finalParams.height))
	node:setPosition(finalParams.x, finalParams.y)



	----页标点相关----------------------------------------------



	---------------------------------------------------

	local function onChange(sender)
		local curPageIdx = sender:getCurrentPageIndex() + 1
		if _prevPage ~= curPageIdx then
			if type(params.onChange) == "function" then
				params.onChange(sender, curPageIdx, _prevPage)
			end
			pointContainer:setSelectedIndex(curPageIdx)

			_prevPage = curPageIdx
		end
	end
	pageView:addEventListener(onChange)


	----调整原有API，索引统一为1-N-------------------------------------------

	--往最后增加页
	function node:addPage()
		local page = ccui.Layout:create()
		pageView:addPage(page)
		_numPages = _numPages + 1
		pointContainer:addPoint()

		onChange(pageView)
		return page
	end

	--在指定索引位置插入页
	function node:insertPage(idx)
		if idx < 1 then idx = 1 end

		local page = ccui.Layout:create()
		pageView:insertPage(page, idx-1)
		_numPages = _numPages + 1
		pointContainer:addPoint()

		return page
	end

	--删除指定索引位置页
	function node:removePage(pageNode)
		if pageNode then
			pageView:removePage(pageNode)
			_numPages = _numPages - 1
		end
	end

	--删除指定索引位置页
	function node:removePageAtIndex(idx)
		if idx < 1 or idx > _numPages then
			return
		end

		if idx < node:getCurrentPageIndex() then
			_prevPage = _prevPage - 1
		elseif idx == node:getCurrentPageIndex() then
			_prevPage = _prevPage + 1
		end

		pageView:removePageAtIndex(idx-1)
		_numPages = _numPages - 1
		-- print(1, "~~~~~111~~~~~", node:getCurrentPageIndex())

		pointContainer:removePointAtIndex(idx)

		_prevPage = node:getCurrentPageIndex()
		if _numPages <= 0 then
			_prevPage = 0
		end
	end

	--删除所有页
	function node:removeAllPages()
		pageView:removeAllPages()
		_numPages = 0

		pointContainer:removeAllPoints()
	end

	--跳到页
	function node:scrollToPage(idx)
		if idx < 1 then
			idx = 1
		elseif idx > _numPages then
			idx = _numPages
		end

		pageView:scrollToPage(idx - 1)
		onChange(pageView)
	end

	--获取当前页索引
	function node:getCurrentPageIndex()
		return pageView:getCurrentPageIndex() + 1
	end

	--获取当前页索引
	function node:getPage(idx)
		if idx < 1 or idx > _numPages then
			return nil
		end

		return pageView:getItem(idx - 1)
	end

	-----------------------------------------------------------

	--添加子对象到对应页
	--@param	idx			[int]		页码，取值[1-numPages]
	--@param	child		[cc.Node]	子对象
	--@param	...			[int]		zOrder, tag
	function node:addChildToPage(idx, child, ...)
		if idx < 1 or idx > _numPages then
			return nil
		end

		local page = self:getPage(idx)
		if page then
			page:addChild(child, ...)
		end

		return child
	end

	--获取指定页指定tag的子对象
	function node:getChildAtPageByTag(idx, tag)
		if idx < 1 or idx > _numPages then
			return nil
		end

		local page = self:getPage(idx)
		if page then
			return page:getChildByTag(tag)
		end

		return nil
	end

	--设置翻页阀值，像素
	function node:setScrollThreshold(value)
		value = value or 100
		pageView:setUsingCustomScrollThreshold(true)
		pageView:setCustomScrollThreshold(value)
	end

	function node:getPageNum()
		return _numPages
	end

	function node:getPageViewNode()
		return pageView
	end
	--初始化默认页
	for i = 1, finalParams.numPages do
		node:addPage()
	end

	--移动到默认页
	node:scrollToPage(finalParams.defaultPage)
	node:setScrollThreshold(finalParams.scrollThreshold)

	return node
end
