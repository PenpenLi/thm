module("THSTG.UI", package.seeall)
--[[
PageTileView的布局：
colCount = 4
rowCount = 2
1 2 3 4 9 10 11 12  。。。。
5 6 7 8 13 14 15 16 。。。。
]]
--[[
创建列表，列表的每项的索引值为1到n，也就是1到n的tile节点对应dataProvider的1到n的项
当在外部修改dataProvider的时候注意需要更新tileList可视区域的节点状态
@param	dataProvider	[table]		数据源(数组)
{
	{name = "a", pic="a.png"}, --这里的table可以是任意结构，其中每项的结构都相同,且key都是tileList的位置索引
	{name = "b", pic="b.png"}		--处理点击事件的时候需要有__isClick这个属性
}
@param itemTemplate	[function]	子项目创建模板，需返回一个显示对象，并且这个对象具有setState（dataProvider[pos]）方法
@param itemRowGap      [number] 横向间距
@param itemColGap      [number] 纵向间距
@param colCount	      [number]	行数
@param rowCount        [number]  列数
@param itemHeight      [number]  item的高
@param itemWidth       [number]  item的宽
@param isCancelState [bool]     是否支持点击取消状态，值为真的时候selectedPos和lastPos相同时返回onSelectedIndexChange（nil, nil, lastNode, lastPos），
								默认值为false
@param	showPagePoint	[boolean]	是否显示页码标识，默认为true
@param	scrollThreshold	[false, number]		默认false，为false时使用默认翻页阀值（宽度的一半），为数值时表示像素值

@param	onChange	[function]	变更页码时的回调，回调函数的格式如：function callback(event) end，
									其中event格式如：{currentPage:当前页[1-N], lastPage = 变更前选择的页[1-N], tag = 对应TileList的tag}
@param  style              [table]  样式
		style.bgColorType   [number]   背景类型，ccui.LayoutBackGroundColorType之一, 默认ccui.LayoutBackGroundColorType.none
		style.bgColor       [number]   背景颜色， THSTG.UI.COLOR_WHITE等值，其中style.bgColorType不能为ccui.LayoutBackGroundColorType.none, 否则设置的值无效
		style.pagePoint = {
				selectedSkin = "a.png", [string]	选中页标资源路径
				unselectedSkin = "b.png", [string]	未选中页标资源路径
				gap = 8, [number]	页标间隔
				offset = 30					[number]	页标栏y坐标偏离值
}
@param  onSelectedIndexChange      [function(this, selectedNode, selectedPos, lastNode, lastPos)]选中回调函数，值不可能同时为nil但都可能为nil
									selecteNode: 	选中的节点， 可能为nil
									selectedPos：	选中的位置， 可能为nil
									lastNode： 		上次选中的节点，可能为nil
									lastPos： 		上次选中的位置，可能为nil
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
]]

function newPageTileView(params)

	local function warnLog(str)
		print("newTileList warning: "..str)
	end
	local  function getTableCount(table)
		local tilenum = 0
		for k, v in pairs(table) do
			tilenum = tilenum + 1
		end
		return tilenum
	end
	local function copyTable(table)
		local ret = {}
		for k, v in pairs(table) do
			if type(v) ~= "table" then
				ret[k] = v
			else
				ret[k] = copyTable(v)
			end
		end
		return ret
	end

	local tilelist = nil


	--私有成员
	local privateData = {}
	privateData.dataProvider = {}
	privateData.viewNode = {}
	privateData.onSelectedIndexChange = params.onSelectedIndexChange
	privateData.selectedState = {}   --保存各个位置的选中状态
	privateData.isCancelState = false

	local function getLastSelectedValue (referrencePos)
		referrencePos = referrencePos or 1
		local dp = tilelist:getDataProvider()
		for i = referrencePos, 1, -1 do
			if dp[i].__isClick then
				return dp[i], tilelist:getNode(i), i
			end
		end
		for i = referrencePos + 1, #dp do
			if dp[i].__isClick then
				return dp[i], tilelist:getNode(i), i
			end
		end
		return nil, nil, nil
	end

	local itemTemplate = function ()
		return cc.Node:create()
	end
	local x = 0
	local y = 0
	local anchorPoint = cc.p(0, 0)
	local onRollIn = function (node, pos)
		warnLog("rollin: "..tostring(pos))
		privateData.viewNode[pos] = node
		local minPos = tilelist:getMinViewPos()
		local maxPos = tilelist:getMaxViewPos()
		for k, v in pairs(privateData.viewNode) do
			if k < minPos or k > maxPos then
				privateData.viewNode[k] = nil
			end
		end

		local v = privateData.dataProvider[pos]
		if v and type(node.setState) == "function" then
			node:setState(v, pos)
		end
	end
	local onSelected = function (selectedNode, selectedPos, lastNode, lastPos, force)
		print("onSelected trigger.")
		if privateData.onSelectedIndexChange then
			local selectedValue = tilelist:getDataProvider()[selectedPos]
			local lastValue = nil
			if lastPos then
				lastValue, lastNode, lastPos = getLastSelectedValue(lastPos)
			end
			if privateData.isCancelState then
				if selectedNode == lastNode then
					if selectedValue.__isClick then
						selectedPos = nil
						selectedNode = nil
						selectedValue = nil
					else
						lastPos = nil
						lastNode = nil
						lastValue = nil
					end

				end
				print("lastPos: "..tostring(lastPos))
			else
				if selectedNode == lastNode and selectedValue.__isClick then
					if force then
						lastPos, lastNode, lastValue = nil, nil, nil
					else
						selectedPos, selectedNode, lastPos, lastNode = nil, nil, nil, nil
					end
					print("selectedNode == lastNode and selectedValue.__isClick true")
				end
			end
			if selectedPos or lastPos then
				if selectedValue then
					selectedValue.__isClick = true
				end
				if lastValue then
					lastValue.__isClick = false
				end
				privateData.onSelectedIndexChange(tilelist, selectedNode, selectedPos, lastNode, lastPos)
			end
		else
			warnLog("privateData.onSelectedIndexChange is nil")

		end
	end


	local tilenum = getTableCount(privateData.dataProvider)
	local style = params.style or {}
	style.pagePoint = style.pagePoint or {}
	style.pagePoint.offsetY = style.pagePoint.offsetY or -20
	tilelist = THSTG.UI.newPageView({
		x = params.x, y = params.y,
		anchorPoint = params.anchorPoint,
		showPagePoint = params.showPagePoint,
		scrollThreshold = params.scrollThreshold,
		onChange = params.onChange,
		style = style,
		numPages = 1,
	})

	local itemRowGap = params.itemRowGap or 0
	local itemColGap = params.itemColGap or 0

	local padding = params.padding or {}
	padding.left = padding.left or itemRowGap / 2
	padding.right = padding.right or 0
	padding.top = padding.top or  itemColGap / 2
	padding.bottom = padding.bottom or itemColGap / 2

	local viewSInit = true
	local hideNode = THSTG.UI.newAutoHideNode({
		itemNum = tilenum,
		x = padding.left,
		y = padding.bottom,
		itemColGap = params.itemColGap,
		itemRowGap = params.itemRowGap,
		colCount = params.colCount,
		rowCount = params.rowCount,
		rectNode = tilelist:getPageViewNode(),
		itemWidth = params.itemWidth,
		itemHeight = params.itemHeight,
		itemTemplate = params.itemTemplate,
		isForce = params.isForce,
		onItemNumChange = function (sender, itemNum)
			local size = sender:getPageSize()
			if viewSInit then
				viewSInit = false
				tilelist:setContentSize(cc.size(size.width + itemRowGap, size.height + (padding.top + padding.bottom)))
				viewS = tilelist:getContentSize()
			end
			local numPages = tilelist:getPageNum()
			local pageNum = sender:getItemNumPerPage()
			local itemNum = sender:getTileNum()
			local needPage = math.ceil(itemNum / pageNum)
			if needPage > numPages then
				for i = numPages + 1, needPage do
					tilelist:addPage()
				end
			elseif needPage < numPages then
				for i = 1, numPages - needPage do
					tilelist:removePageAtIndex(tilelist:getPageNum())
				end
			end
		end,
		onRollIn = function (sender, node, pos)
			onRollIn(node, pos)
		end,
		onRollOut = function (sender, pos)

		end,
		onSelected = onSelected,
		onUpdate = function (sender)
			if tilelist:getPageNum() >= 1 then
				local firstPage = tilelist:getPage(1)
				local pos = cc.p(firstPage:getPosition())
				sender:setPosition(cc.p(pos.x + padding.left, pos.y + padding.bottom))
				--printTable(168, pos)
			end
		end
	})

	--重载布局函数
	function hideNode:getUserPos(pos)
		local x, y = 0, 0
		local tileInfo = hideNode:getTileInfo()
		x = math.floor((pos - 1) / tileInfo.rowCount) + 1
		y = (pos - 1) % tileInfo.rowCount + 1
		local pageNum = math.floor((x - 1) / tileInfo.colCount) + 1
		local pageX = (x  - 1) % tileInfo.colCount + 1
		local pageY = tileInfo.rowCount - y + 1
		local startX = (pageNum - 1) * hideNode:getItemNumPerPage() + 1
		return startX + (pageX - 1) + (pageY - 1) * tileInfo.colCount

	end

	function hideNode:getLocalPos(pos)
		local x, y = 0, 0
		local tileInfo = hideNode:getTileInfo()

		local pageNum = math.floor((pos - 1) / hideNode:getItemNumPerPage()) + 1
		local left = (pos - 1) % hideNode:getItemNumPerPage()
		y = math.floor(left / tileInfo.colCount) + 1
		x = (pageNum - 1) * tileInfo.colCount + (pos - 1) % tileInfo.colCount + 1

		y = tileInfo.rowCount - y + 1

		return (x - 1) * tileInfo.rowCount + 1 + (y - 1)

	end

	--[[删除操作，重新摆放受影响的节点位置，外部不直接使用]]
	function tilelist:deleteTile(position)
		hideNode:delete(position)
	end

	--[[插入操作，重新摆放受影响的节点位置， 外部不直接使用]]
	function tilelist:insertTile(position)
		hideNode:insert(position)
	end

	function tilelist:updateTile(position)
		if position >= self:getMinViewPos() and position <= self:getMaxViewPos() then
			hideNode:update(position)
		end
	end
	--[[获取可视区域最小的显示位置
	]]
	function tilelist:getMinViewPos()
		return hideNode:getMinViewPos()
	end

	--[[
	获取显示区域最大的显示位置
	]]
	function tilelist:getMaxViewPos()
		return hideNode:getMaxViewPos()
	end

	function tilelist:getViewItemPos()
		return hideNode:getViewItemPos()
	end

	--[[
	获取某个索引的位置，这里获取的世界坐标
	@param index索引 number
	]]
	function tilelist:getPositionAtIndex(index)
		local position = cc.p(0, 0)
		if index then
			position = hideNode:getWorldPosition(index)
		else
			warnLog("self:getPositionAtIndex() ~= #privateData.dataProvider")
		end
		return position
	end

	--[[
	获取item的size
	]]
	function tilelist:getItemSize()
		local itemInfo = hideNode:getTileInfo()
		return  cc.size(itemInfo.itemWidth, itemInfo.itemHeight)
	end

	--[[
	设置显示区域最小的显示位置，可控制从第几列或第几行开始显示，
	例：tileList布局为：
		0 1 2
		3 4 5
		6 7 8
		。。。
		position的值为0， 1， 2则表示从第一行开始显示，以此类推，纵向的原理一样
	]]
	function tilelist:setMinViewPos(position)
		if position >= 1 and position <= tilelist:getTileNum() then

			tilelist:scrollToPage(math.floor(position - 1) / hideNode:getItemNumPerPage() + 1)
		end

	end

	function tilelist:getTileNum()
		return hideNode:getTileNum()
	end

	function tilelist:setTileNum(num)
		hideNode:setTileNum(num)
	end

	local function checkValid(self)
		if self:getTileNum() ~= #privateData.dataProvider then
			warnLog("self:getTileNum() ~= #privateData.dataProvider")
			return false
		end
		return true
	end

	--扩展api,这里除了get方法之外，其他方法都会更新可视区域的节点，所以修改dataProrider的时候应该注意更新节点带来的效率损失

	--[[设置dataProvider
	--@param dataProvider [table]数据源，格式需要与规定的格式一致
	]]
	function tilelist:setDataProvider(dataProvider)
		if type(dataProvider) == "table" then
			if dataProvider.__cname == "TileListData" then
				dataProvider:addTileList(self)
			else
				privateData.dataProvider = dataProvider
				self:setTileNum(getTableCount(dataProvider))
			end

		else
			warnLog("setDataProvider dataProvider wrong type: "..type(dataProvider))
		end

	end

	--[[获取数据源
	]]
	function tilelist:getDataProvider()
		return privateData.dataProvider
	end

	--[[更新数据源
	@param position  [int]位置
	@param value     []更新的值
	]]
	function tilelist:updateDataProvider(position, value)
		if checkValid(self) then
			if type(position) == "number" and value then
				privateData.dataProvider[position] = value
				if position >= self:getMinViewPos() and position <= self:getMaxViewPos() then
					hideNode:update(position)
				end

			else
				warnLog("updateDataProvider position wrong type: "..type(position))
			end
		end

	end

	--[[删除数据源的项
	@position  [int]位置
	@isAction  [bool]false or nil这只删除不播动画， 否则当删除可视区域的item时且是一行或一列的情况会播动画
	]]
	function tilelist:deleteData(position, isAction)
		if checkValid(self) then
			if type(position) == "number" then
				if privateData.dataProvider[position] then
					local tileNum = self:getTileNum()
					table.remove(privateData.dataProvider, position)
					self:deleteTile(position)
					if isAction then
						hideNode:applyDeleteAction(position)
					end

				else
					warnLog("self.__dataProvider[position] is nil")
				end


			else
				warnLog("deleteData position wrong type: "..type(position))
			end
		end

	end

	--[[插入数据源项
	@param position  [int]位置，为nil时默认插入到最后一位
	@param value     []插入的值
	]]
	function tilelist:insertData(value, position)
		if checkValid(self) then
			if position then
				if privateData.dataProvider[position] then
					if value then
						table.insert(privateData.dataProvider, position, value)
						self:insertTile(position)
					else
						warnLog("insertData value is nil")
					end
				else
					warnLog("self.__dataProvider[position] is nil")
				end
			else
				if value then
					table.insert(privateData.dataProvider, value)
					self:insertTile(#privateData.dataProvider)
				else
					warnLog("insertData value is nil")
				end
			end
		end

	end

	--[[获取可视区域的节点
	@param position 从1开始
	]]
	function tilelist:getNode(position)
		if type(position) == "number" then
			local minPos = self:getMinViewPos()
			local maxPos = self:getMaxViewPos()
			local tarPos = position
			if tarPos <= maxPos and tarPos >= minPos then
				return privateData.viewNode[tarPos]
			else
				warnLog("getNode position is wrong value is : "..tostring(position).." max: "..(maxPos).." min: "..minPos)
			end
		else
			warnLog("getNode position is not number")
		end
	end

	--屏蔽
	privateData.registerRollInHandler = tilelist.registerRollInHandler
	tilelist.registerRollInHandler = nil
	privateData.registerSelectedHandler = tilelist.registerSelectedHandler
	tilelist.registerSelectedHandler = nil

	tilelist:setDataProvider(params.dataProvider or {})

	return tilelist

end
