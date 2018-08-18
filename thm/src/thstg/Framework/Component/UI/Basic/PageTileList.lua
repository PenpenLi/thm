module("THSTG.UI", package.seeall)

--默认页标是否可见
PAGE_TILE_LIST_DEFAULT_PAGE_TAB_VISIBLE = true

--默认样式
PAGE_TILE_LIST_DEFAULT_STYLE = {
	itemGap = 10,
	paddingX = 5,
	paddingY = 0,
	pageTab = {
		-- selectedSkin = ResManager.getComponentRes(ComponentTypes.TILE_LIST, "pageTabSelected"),
		-- unselectedSkin = ResManager.getComponentRes(ComponentTypes.TILE_LIST, "pageTabUnselected"),
		gap = 30,
		height = 26
	}
}
--默认宽度
PAGE_TILE_LIST_DEFAULT_WIDTH = 300
--默认高度
PAGE_TILE_LIST_DEFAULT_HEIGHT = 300
--默认页数
PAGE_TILE_LIST_DEFAULT_PAGE_COUNT = 3
--默认行数
PAGE_TILE_LIST_DEFAULT_ROW_COUNT = 3
--默认列数
PAGE_TILE_LIST_DEFAULT_COL_COUNT = 3


--[[
创建FRTileList

@param	dataProvider	[table]		数据源，数组
@param	itemTemplate	[function]	每一个格子的创建模板，如function itemTemplate(data) end，其中data参数对应dataProvider数组中的一项
@param	pageCount		[number]	总页数(注意该组件若页数大于3的，需要对其模版node进行remove, 然后在重新add)
@param	colCount		[number]	行数
@param	rowCount		[number]	列数
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]	锚点(如UI.POINT_LEFT_BOTTOM)
@param	pageTabVisible	[boolean]	是否显示页码标识
@param	style			[table]		样式
{
	itemGap = 46, [number]	格子间的间隔
	paddingX = 10, [number]	格子间的间隔
	paddingY = 0, [number]	格子间的间隔
	pageTab = {
		selectedSkin = "a.png", [string]	选中页标资源路径
		unselectedSkin = "b.png", [string]	未选中页标资源路径
		gap = 8, [number]	页标间隔
		height = 30					[number]	页标栏高度
}
}
@param	onPageChange	[function]	变更页码时的回调，回调函数的格式如：function callback(event) end，
									其中event格式如：{currentPage:当前页[1-N], lastPage = 变更前选择的页[1-N], tag = 对应TileList的tag}
@param	onItemTap		[function]	点击其中一项的回调，回调函数的格式如：function callback(event) end，
									其中event格式如：
									单选：{itemTapIndex:点击的格子的index, selectedIndex = 选中格子的index, lastSelectedIndex = 上次选中格子的index}
									多选：{itemTapIndex:点击的格子的index, selectedIndexes = {1, 2, ...}：所有选择中的格子数组}
]]
function newPageTileList(params)
	assert(params ~= nil, "PageTileList params is required!")
	assert(params.itemTemplate and type(params.itemTemplate) == "function", "TileList itemTemplate is required!")

	if params.dataProvider == nil then params.dataProvider = {} end

	local w, h = params.width or 300, params.height or 300
	local pageCount = params.pageCount or PAGE_TILE_LIST_DEFAULT_PAGE_COUNT
	local colCount = params.colCount or PAGE_TILE_LIST_DEFAULT_ROW_COUNT
	local rowCount = params.rowCount or PAGE_TILE_LIST_DEFAULT_COL_COUNT
	local pageTabVisible = PAGE_TILE_LIST_DEFAULT_PAGE_TAB_VISIBLE
	if type(params.pageTabVisible) == "boolean" then pageTabVisible = params.pageTabVisible end

	local style = THSTG.TableUtil.mergeA2B(params.style, PAGE_TILE_LIST_DEFAULT_STYLE)
	--每页格子数
	local numCellsPerPage = colCount * rowCount

	--存放用itemTemplate创建出来的CCNode对象
	local nodes = FRArray:create()

	--需要创建的格子数量
	local numCreate = numCellsPerPage
	if pageCount > 1 then
		numCreate = numCellsPerPage * 2
	end
	--if pageCount==0  then numCreate=0 end
	for i = 1, numCreate do
		local node = params.itemTemplate(params.common)
		if type(node.setData) == "function" then
			node:setData(params.dataProvider[i])
		end
		nodes:addObject(node)
	end

	local list

	local function onPageChange(event)
		local curPage, lastPage = event.currentPage, event.lastPage
		--pageCount = event.self:getNumOfPages()
		if curPage > lastPage then--右翻
			if curPage < pageCount then--未达尾页
				if numCreate < numCellsPerPage * 3 then--没创建够3页cc.Node
					local from, to, node = nodes:count() + 1, numCellsPerPage * 3
					for i = from, to do
						node = params.itemTemplate(params.common)
						if type(node.setData) == "function" then
							node:setData(list.__dataProvider__[i])
						end
						nodes:addObject(node)
					end
			end

			if curPage > 2 then
				--第1页与第2页交换
				for i = 1, numCellsPerPage do
					nodes:objectAtIndex(i-1):setData(list.__dataProvider__[curPage * numCellsPerPage + i])
					nodes:exchangeObjectAtIndex(i-1, numCellsPerPage + i - 1)
				end
				--第2页与第3页交换
				for i = numCellsPerPage + 1, numCellsPerPage * 2 do
					nodes:exchangeObjectAtIndex(i-1, numCellsPerPage + i - 1)
				end
			end
		end
		else
			if curPage > 1 and curPage < pageCount - 1 then--未达首页且未在尾页
				for i = numCellsPerPage + 1, numCellsPerPage * 2 do
					nodes:exchangeObjectAtIndex(i-1, numCellsPerPage + i - 1)
			end
			for i = 1, numCellsPerPage do
				nodes:exchangeObjectAtIndex(i-1, numCellsPerPage + i - 1)
				nodes:objectAtIndex(i-1):setData(list.__dataProvider__[(curPage-2) * numCellsPerPage + i])
			end
			end
		end

		if params.onPageChange then
			params.onPageChange(event)
		end
	end

	list = FRPageTileList:create(nodes, cc.size(w, h), pageCount, colCount, rowCount, style.itemGap, pageTabVisible)
	list.__dataProvider__ = params.dataProvider
	list.__pageCapacity__ = numCellsPerPage

	list:setPadding(style.paddingX, style.paddingY)

	if pageTabVisible then
		local skin = cc.Sprite:create(style.pageTab.selectedSkin)
		local selectedSkinRect = skin:boundingBox()
		selectedSkinRect.origin.x = 0
		selectedSkinRect.origin.y = 0
		skin:release()

		skin = cc.Sprite:create(style.pageTab.unselectedSkin)
		local unselectedSkinRect = skin:boundingBox()
		unselectedSkinRect.origin.x = 0
		unselectedSkinRect.origin.y = 0
		skin:release()

		list:setPageTabStyle(style.pageTab.unselectedSkin, style.pageTab.selectedSkin, style.pageTab.height, style.pageTab.gap, selectedSkinRect, unselectedSkinRect)
	end
	list:registerPageChangeScriptFunc(onPageChange)
	if params.onItemTap then
		list:registerItemTapScriptFunc(params.onItemTap)
	end
	list:setPosition(params.x or 0, params.y or 0)

	-------------------------------------------------------

	--获取当前数据源
	function list:getDataProvider()
		return self.__dataProvider__
	end
	--设置数据源
	function list:setDataProvider(value)
		local newLen, oldLen = #value, #self.__dataProvider__
		local len = newLen
		if len < oldLen then
			len = oldLen
		end

		for i = 1, len do
			local data = (i <= newLen and value[i] or false)
			self:updateItemAtIndex(data, i, false)
			--这是废话，可以忽略。如果有一天你初始的页数只有一页,后来你想增加数据源,增加两页以上setDataProvider发现崩了 请尝试将上面那句注释掉，改成使用 self.__dataProvider__[i] = data
		end

		--self:needLayout()
	end
	--[[
	更新数据源中一组索引位置的数据信息
	@param	updateInfos		需要更新的数据数组，结构如下（index：对应dataProvider中某项的索引，data：对应dataProvider中某项的数据）：
							{
								{index = 1, data = {itemInfo = {}, itemExInfo = {}, ...}}, 
								{index = 2, data = {itemInfo = {}, itemExInfo = {}, ...}}, 
}
	]]
	function list:updateDataProvider(updateInfos)
		for k, v in ipairs(updateInfos) do
			self:updateItemAtIndex(v.data, v.index, false)
		end
		self:needLayout()
	end
	--[[
	更新指定index位置的显示数据
	@param	data		[table]		数据d
	@param	index		[number]	索引位置
	@param	layoutNow	[boolean]	是否立即刷新显示
	]]
	function list:updateItemAtIndex(data, index, layoutNow)
		if layoutNow ~= false then layoutNow = true end

		self.__dataProvider__[index] = data
		local itemRender = self:getNodeAtIndex(index)
		if itemRender and type(itemRender.setData) == "function" then
			itemRender:setData(data, index)
		end

		if layoutNow == true then
			self:needLayout()
		end
	end
	--获取dataProvider中对应index位置的cc.Node对象，与页码有关
	function list:getNodeAtIndex(index)
		local fromPage = self:getCurrentPageLua() - (self:getCurrentPageLua() < pageCount and 2 or 3)
		local from, to = fromPage * numCellsPerPage + 1, (self:getCurrentPageLua() + 1) * numCellsPerPage
		local maxTo = math.max(#self.__dataProvider__, self:getDataList():count())
		if from <= 0 then from = 1 end
		if to > maxTo then to = maxTo end
		if index >= from and index <= to then
			return self:getDataList():objectAtIndex(index - from)
		end
		return nil
	end

	function list:createNewPageLua(num)
		if num > 0 and pageCount == 1 then
			local numCellsPerPage = colCount * rowCount
			local numCreate = numCellsPerPage * 2
			for i = numCellsPerPage + 1, numCreate do
				local node = params.itemTemplate(params.common)
				if type(node.setData) == "function" then
					node:setData(params.dataProvider[i])
				end
				nodes:addObject(node)
			end
		end
		pageCount = pageCount + num
		list:createNewPage(num)

	end

	local function onCleanup()
		list.getNodeAtIndex = nil
		list.updateItemAtIndex = nil
		list.updateDataProvider = nil
		list.setDataProvider = nil
		list.getDataProvider = nil
		list.__dataProvider__ = nil
		list.__pageCapacity__ = nil
	end
	list:onNodeEvent("cleanup", onCleanup)

	return list
end
