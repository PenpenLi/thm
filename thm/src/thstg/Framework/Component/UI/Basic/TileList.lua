module("UI", package.seeall)
--[[创建辅助节点
@params  colCount    		[number]  列数    
@params  rowCount 			[number]  行数
@params  itemNum            [number]  总个数
@params  itemColGap         [number]  纵列节点间的间隔
@params  itemRowGap         [number]  横排节点间的间隔
@params  itemTemplate       [function()] 节点函数模板
@params  itemTemplateParams [any]       模块参数
@params  itemWidth          [number]   节点宽度，nil时取模板节点宽度
@params  itemHeight         [number]    节点高度， nil时取模板节点宽度
@params  rectNode           [cc.node]   矩形显示节点
@params  onUpdate           [function(sender)] 每针更新回调函数
@params  isVertical         [Boolean]  是否垂直滚动
@params  onItemNumChange    [function(sender, itemNum)]节点个数发生改变时回调函数
@params  onRollIn           [function(sender, contentNode, position)]节点滚进回调
@params  onRollOut          [function(sender, position)]节点滚出回调
@params  onSelected         [function(selecteNode, selectedPos, lastNode, lastPos)]节点选择回调函数, 
@params  isForce            [boolean] 选中状态，再次点击是否触发事件
@params  isReverseZOrder 	[boolean] zorder反向排序
@params  swallowTouches     [boolean] 默认为true
]]
function newAutoHideNode(params)

	local function tipLog(str)
	-- print(168, "newAutoHideNode: "..tostring(str))
	end
	params = params or {}
	params = clone(params)

	params.colCount = params.colCount or 5
	params.rowCount = params.rowCount or 5
	params.itemNum = params.itemNum or 0
	params.itemColGap = params.itemColGap or 0
	params.itemRowGap = params.itemRowGap or 0
	local itemNode = params.itemTemplate(params.itemTemplateParams)
	params.itemWidth = params.itemWidth or itemNode:getContentSize().width
	params.itemHeight = params.itemHeight or itemNode:getContentSize().height
	params.itemWidth = math.max(1, params.itemWidth)
	params.itemHeight = math.max(1, params.itemHeight)

	local hideNode = ccui.Layout:create()

	local privateData = {}
	privateData.isCellDirty = false  -- cell table是否发生改变
	privateData.cell = {}  --当前针需要检查更新的格子 {_content, isDirty, _pos, _isHide, _userPos}
	privateData.unusedCellNode = {} --不可见的cell
	privateData.needCreateTile = {} --需要创建的Tile
	privateData.lastTestPos = nil --上次测试点
	privateData.lastUpdateTime = 0
	privateData.nodeNum = 0
	privateData.lastItemNum = nil --上次记录的个数
	privateData.lastClickCell = nil -- 上次点击的cell
	privateData.zOrderFlag = params.isReverseZOrder and -1 or 1
	--相关删除动画参数
	privateData.deletePos = -1
	privateData.deleteActionTime = 0
	privateData.deleteActionDuration = 0.3

	local director = cc.Director:getInstance()

	function privateData.init()
		params.rectNode:addChild(hideNode)
		hideNode:setPosition(cc.p(params.x or 0, params.y or 0))

		hideNode:onNodeEvent("enter", function (...)
			local eventDispatcher = director:getEventDispatcher()
			privateData.afterUpdateListener = cc.EventListenerCustom:create("director_after_update", privateData.update)
			eventDispatcher:addEventListenerWithFixedPriority(privateData.afterUpdateListener, 1)
		end)

		hideNode:onNodeEvent("exit", function (...)
			local eventDispatcher = director:getEventDispatcher()
			eventDispatcher:removeEventListener(privateData.afterUpdateListener)
			privateData.afterUpdateListener = nil
			tipLog("remove afterUpdateListener")
		end)
	end


	--核心函数
	---------------------------------------------------------------------------------------------
	--[更新逻辑]
	function privateData.update()

		--onUpdate
		if params.onUpdate then
			params.onUpdate(hideNode)
		end

		--更新cellTable
		privateData.updateCell()

		-- --创建格子节点
		-- privateData.objectCreate()

		--处理rollOut
		privateData.doRollOut()

		--rollIng
		privateData.doRollIn()

		--更新动画
		privateData.updateDeleteAction()
	end

	--更新格子变化
	function privateData.updateCell()
		if privateData.lastItemNum ~= params.itemNum then
			privateData.lastItemNum = params.itemNum
			if params.onItemNumChange then
				params.onItemNumChange(hideNode, params.itemNum)
			end
		end

		local vsize = params.rectNode:getContentSize()
		local testPos = cc.p(0, vsize.height)
		testPos = params.rectNode:convertToWorldSpace(testPos)
		testPos = hideNode:convertToNodeSpace(testPos)
		if not privateData.lastTestPos  or  (testPos.x ~= privateData.lastTestPos.x or testPos.y ~= privateData.lastTestPos.y) or privateData.isCellDirty then
			privateData.lastTestPos = testPos
			privateData.isCellDirty = true
			--设置cell的可见性
			for k, v in pairs(privateData.cell) do
				privateData.setHide(v, not privateData.isCellInShow(v._pos))
			end

			--把显示的格子添加到cell table
			local showMin, showMax = privateData.getShowColOrRowRange(testPos)

			for i = showMin, showMax do
				local start = (i - 1) * privateData.getRowOrColCount() + 1
				for i = start, start + privateData.getRowOrColCount() - 1 do
					local userPos = hideNode:getUserPos(i)
					if privateData.hasContent(userPos) then
						privateData.addCell(userPos)
					end
				end
			end
			privateData.updateCellPosition()
		end
	end

	--创建模板节点
	function privateData.objectCreate()
		if params.itemTemplate then
			local k = #privateData.needCreateTile
			if k >= 1 then
				local contentNode = params.itemTemplate(params.itemTemplateParams)
				if contentNode then
					local trect = UI.newWidget({
						touchEnabled = true,
						swallowTouches = params.swallowTouches == nil and true or params.swallowTouches,
						onClick = privateData.clickEventhandler,
						onTouch = params.onTouch,
					})
					local contentNodeAr = contentNode:getAnchorPoint()
					local contentNodeS = contentNode:getContentSize()
					trect:setContentSize(contentNodeS)
					trect:setAnchorPoint(cc.p(0.5, 0.5))
					contentNode:setPosition(cc.p(contentNodeAr.x * contentNodeS.width, contentNodeAr.y * contentNodeS.height))
					trect:addChild(contentNode)
					hideNode:addChild(trect)
					trect._content = contentNode

					privateData.addUnusedCellNode(trect)
					privateData.nodeNum = privateData.nodeNum + 1
					tipLog("testContentNodeCount: "..privateData.nodeNum)
				else
					tipLog("objectcreate fun create null")
				end
				privateData.needCreateTile[k] = nil
			end
		end
	end

	--计算cell的rollIn，rollOut
	function privateData.doRollOut()
		if privateData.isCellDirty then
			privateData.isCellDirty = false
			--移除不可见格子
			privateData.removeHideCell()
		end
	end

	--节点更新
	function privateData.doRollIn()
		local deltime = director:getDeltaTime()
		local startT = os.clock()
		local maxDur = 10000 --0.033
		if deltime <= maxDur or deltime - privateData.lastUpdateTime <= 0.020 then
			--创建格子节点
			privateData.objectCreate()

			local cellItem = privateData.getDirtyCell()
			if cellItem and not cellItem._node then
				privateData.addContentToCell(cellItem)
			end

			while cellItem and cellItem._node do
				cellItem._isDirty = false
				if params.onRollIn then
					cellItem._node:setLocalZOrder(cellItem._pos * privateData.zOrderFlag)
					params.onRollIn(hideNode, cellItem._node._content, cellItem._pos)
				end
				if (os.clock() - startT + deltime) <= maxDur then
					--创建格子节点
					privateData.objectCreate()
					cellItem = privateData.getDirtyCell()
					if cellItem and not cellItem._node then
						privateData.addContentToCell(cellItem)
					end
				else
					break
				end
			end
		end

		privateData.lastUpdateTime = deltime
	end

	--[[一行一列的删除动画]]
	function privateData.updateDeleteAction()
		if privateData.deletePos >= 1  then
			privateData.deleteActionTime = privateData.deleteActionTime + director:getDeltaTime()
			if privateData.deleteActionTime >= privateData.deleteActionDuration then
				privateData.deleteActionTime = 0
				privateData.deletePos = -1
			end

			privateData.updateCellPosition()
		else

		end
	end
	---------------------------------------------------------------------------------------------

	--格子cell的相关操作
	----------------------------------------------------------------------------------------------
	--[[添加格子到具体位置]]
	function privateData.addCell(pos)
		if not privateData.getCellByPos(pos) then
			local item = privateData.newCell(pos)
			privateData.cell[item] = item
			privateData.isCellDirty = true
		end
	end
	--[[插入格子到具体位置]]
	function privateData.insertCell(pos)
		local itemcell = privateData.getCellByPos(pos)

		for k, v in pairs(privateData.cell) do
			local realPos = v._pos
			local realPos2 = pos
			if realPos >= realPos2 then
				privateData.setCellPos(v, realPos + 1)
			end
		end

		if not itemcell then
			privateData.addCell(pos)
		end


		privateData.isCellDirty = true
	end
	--[[获取对应的格子]]
	function privateData.getCellByPos(pos)
		for k, v in pairs(privateData.cell) do
			if v._pos == pos then
				return v
			end
		end
	end
	--[[设置格子的位置]]
	function privateData.setCellPos(cell, pos)
		cell._pos = pos
		if cell._node then
			if privateData.deletePos >= 1 and  privateData.deletePos <= cell._pos then
				local offset = cc.p(0, 0)
				if params.isVertical then
					offset.y = offset.y + privateData.deleteActionTime / privateData.deleteActionDuration * (params.itemHeight + params.itemColGap)
				else
					offset.x = offset.x - privateData.deleteActionTime / privateData.deleteActionDuration * (params.itemWidth + params.itemRowGap)
				end
				local npos = privateData.get2DPosByPos(cell._pos + 1)
				cell._node:setPosition(cc.p(npos.x + offset.x, npos.y + offset.y))
			else
				cell._node:setPosition(privateData.get2DPosByPos(cell._pos))
			end

		end
	end
	--[[移除cell]]
	function privateData.removeCell(cell)
		if cell._node then
			privateData.addUnusedCellNode(cell._node)
		end

		privateData.cell[cell] = nil
	end
	--[[添加内容节点到cell]]
	function privateData.addContentToCell(cell)
		if not cell._node then
			local k, v = privateData.getUnusedCellNode(cell._pos)
			if v then
				cell._node = v
				cell._node:show()
				cell._node:setPosition(privateData.get2DPosByPos(cell._pos))
				cell._node:setLocalZOrder(cell._pos)
				cell._node._cell = cell
				cell._node._pos = cell._pos
				privateData.isCellDirty = true
			end
		end

	end
	--[[移除不可见的cell]]
	function privateData.removeHideCell()
		for k, v in pairs(privateData.cell) do
			if v._isHide then
				if v._node then
					if params.onRollOut then
						params.onRollOut(hideNode, v._pos)
					end
				end
				v._isHide = nil
				privateData.removeCell(v)
			end
		end
	end
	--[[更新具体位置的cell]]
	function privateData.updateItemCell(pos)
		local itemcell = privateData.getCellByPos(pos)
		if itemcell then
			itemcell._isDirty = true
			privateData.isCellDirty = true
		end
	end
	--[[删除具体位置的cell]]
	function privateData.deleteCell(pos)
		local itemcell = privateData.getCellByPos(pos)
		if itemcell then
			if  privateData.lastClickCell == itemcell then
				privateData.lastClickCell = false
			end
			privateData.removeCell(itemcell)
		end
		for k, v in pairs(privateData.cell) do
			local realPos = v._pos
			local realPos2 = pos
			if realPos2 < realPos then
				privateData.setCellPos(v, realPos - 1)
			end

		end

		privateData.isCellDirty = true
	end
	--[[移除所有的cell]]
	function privateData.removeAllCell()
		privateData.lastClickCell = false
		for k, v in pairs(privateData.cell) do
			privateData.removeCell(v)
		end
		privateData.isCellDirty = true
	end
	--[[设置cell的可见性]]
	function privateData.setHide(cell, value)
		local itemCell = cell
		if itemCell._isHide ~= value then
			itemCell._isHide = value
			privateData.isCellDirty = true
		end
	end

	----------------------------------------------------------------------------------------------

	function privateData.onSelectedChange(position, force)
		local curCell = privateData.getCellByPos(position)
		if not curCell and privateData.hasContent(position) then
			curCell = privateData.newCell(position)
		end
		if params.onSelected and curCell then
			local selecteNode, lastNode, selectedPos, lastPos = nil, nil, nil, nil
			if curCell._node then
				selecteNode = curCell._node._content
			end
			selectedPos = curCell._pos

			if privateData.lastClickCell then
				if privateData.cell[privateData.lastClickCell] then
					if privateData.lastClickCell._node then
						lastNode = privateData.lastClickCell._node._content
					end
				end
				lastPos = privateData.lastClickCell._pos
				if lastPos > params.itemNum then
					lastPos = nil
				end
			end
			privateData.lastClickCell = curCell
			params.onSelected(selecteNode, selectedPos, lastNode, lastPos, force)
		end
	end

	function privateData.clickEventhandler(sender)
		if sender._cell then
			privateData.onSelectedChange(sender._cell._pos, params.isForce)
		end
	end

	function privateData.addUnusedCellNode(node)
		node:hide()
		privateData.unusedCellNode[node] = node
		node._cell = nil
	end

	function privateData.getUnusedCellNode(pos)
		local k, v
		for k1, v1 in pairs(privateData.unusedCellNode) do
			if v1._pos == pos then
				k, v = k1, v1
				break
			end
		end
		if not k then
			k, v = next(privateData.unusedCellNode)
		end
		if k then
			privateData.unusedCellNode[k] = nil
		end
		return k, v
	end
	function privateData.applyCellNode()
		local viewS = params.rectNode:getContentSize()
		local xNum = math.ceil(viewS.width / (params.itemWidth + params.itemRowGap)) + 2
		local yNum = math.ceil(viewS.height / (params.itemHeight + params.itemColGap)) + 2
		local maxNum = math.max(xNum * privateData.getRowOrColCount(), yNum * privateData.getRowOrColCount())

		if privateData.nodeNum + #privateData.needCreateTile < maxNum then
			table.insert(privateData.needCreateTile, true)
		end
	end

	function privateData.getDirtyCell()
		for k, v in pairs(privateData.cell) do
			if not v._isHide and v._isDirty then
				return v
			end
		end
	end

	function privateData.newCell(pos)
		local cell = {}
		cell._isHide = nil
		cell._pos = pos
		cell._isDirty = true
		cell._node = nil --延迟到rollIn初始化
		privateData.applyCellNode()

		return cell
	end

	function privateData.get2DPosByPos(pos)
		pos = hideNode:getLocalPos(pos)
		local start2DPos = cc.p(params.itemWidth / 2, params.itemHeight / 2)
		local startPos = 1

		local x, y = 0, 0
		if params.isVertical then
			x = (pos - 1) % privateData.getRowOrColCount() + 1
			y = math.ceil(pos / privateData.getRowOrColCount())
		else
			y = (pos - 1) % privateData.getRowOrColCount() + 1
			x = math.ceil(pos / privateData.getRowOrColCount())
		end

		return cc.p(start2DPos.x + (x - startPos) * (params.itemWidth + params.itemRowGap), start2DPos.y + (y - startPos) * (params.itemColGap + params.itemHeight))
	end

	function privateData.getShowColOrRowRange(testPos)
		local vsize = params.rectNode:getContentSize()
		if not testPos then
			testPos = cc.p(0, vsize.height)
			testPos = params.rectNode:convertToWorldSpace(testPos)
			testPos = hideNode:convertToNodeSpace(testPos)
		end

		local min, max, minLen, maxLen = -1, -1, -1, -1
		local itemL = 0
		if params.isVertical then
			maxLen = testPos.y + params.itemColGap + 1
			minLen = testPos.y - vsize.height
			itemL = params.itemHeight + params.itemColGap
		else
			minLen = testPos.x + params.itemRowGap + 1
			maxLen = testPos.x + vsize.width
			itemL = params.itemWidth + params.itemRowGap
		end
		min = math.ceil(minLen / itemL)
		max = math.ceil(maxLen / itemL)
		min = math.max(1, min)
		--max = math.max(min, max)
		return min, max
	end

	function privateData.getRowOrColCount()
		if params.isVertical then
			return params.colCount
		else
			return params.rowCount
		end
	end

	function privateData.getSize()
		local  size = cc.size(0, 0)
		local colCount = privateData.getRowOrColCount()
		local gapCount = colCount - 1
		gapCount = math.max(0, gapCount)

		local rowCount = math.floor((params.itemNum - 1) / colCount) + 1
		local colGapCount = rowCount - 1
		colGapCount = math.max(0, colGapCount)
		if params.isVertical then
			size.width = colCount * params.itemWidth + gapCount * params.itemRowGap
			size.height = rowCount * params.itemHeight + colGapCount * params.itemColGap
		else
			size.height = colCount * params.itemHeight + gapCount * params.itemColGap
			size.width = rowCount * params.itemWidth + colGapCount * params.itemRowGap
		end

		return size
	end

	function privateData.updateCellPosition()
		for k, v in pairs(privateData.cell) do
			if v._node and not v._hide then
				privateData.setCellPos(v, v._pos)
			end
		end
	end

	function privateData.hasContent(pos)
		return  pos <= params.itemNum and pos >= 1
	end
	function privateData.isCellInShow(pos)
		if privateData.hasContent(pos) then
			local showMin, showMax = privateData.getShowColOrRowRange()
			local row = privateData.getRowOrColByCell(pos)
			if row >= showMin and row <= showMax then
				return true
			end
		end
		return false
	end

	function privateData.getRowOrColByCell(pos, islocal)
		if not islocal then
			pos = hideNode:getLocalPos(pos)
		end
		return math.floor((pos - 1) / privateData.getRowOrColCount()) + 1
	end
	--[[
		得带某个索引的世界坐标
	]]

	function hideNode:getWorldPosition(pos)
		return hideNode:convertToWorldSpace(privateData.get2DPosByPos(pos))
	end

	--[[位置布局重载函数,需要不同的计数方式的可重载这两个函数]]
	------------------------------------------------------------------------------------------------
	--[[
		代码实现的布局：
						横向：
						3 6 9
						2 5 8
						1 4 7 。。。
						纵向：
						7 8 9
						4 5 6
						1 2 3
		当前函数已重载为布局：
						横向：
						1 4 7
						2 5 8
						3 6 9
					    纵向：
					    1 2 3
					    4 5 6
					    7 8 9
	]]
	--[[从本地布局到用户布局的转换]]
	function hideNode:getUserPos(pos)
		if params.isVertical then
			local rowNum = math.floor((params.itemNum - 1) / privateData.getRowOrColCount()) + 1
			local posRowNum = privateData.getRowOrColByCell(pos, true)
			local accordRowNum = rowNum + 1 - posRowNum
			pos = pos + (accordRowNum - posRowNum) * privateData.getRowOrColCount()
		else
			pos = pos - 2 * ((pos - 1)%privateData.getRowOrColCount()) + privateData.getRowOrColCount() - 1
		end

		return pos
	end
	--[[从用户布局到本地布局的转换]]
	function hideNode:getLocalPos(pos)
		if params.isVertical then
			local rowNum = math.floor((params.itemNum - 1) / privateData.getRowOrColCount()) + 1
			local posRowNum = math.floor((pos - 1) / privateData.getRowOrColCount()) + 1
			local accordRowNum = rowNum + 1 - posRowNum
			pos = pos + (accordRowNum - posRowNum) * privateData.getRowOrColCount()
		else
			pos = pos - 2 * ((pos - 1)%privateData.getRowOrColCount()) + privateData.getRowOrColCount() - 1
		end
		return pos
	end
	--------------------------------------------------------------------------------------------------------
	--外部接口
	--[插入到具体位置]
	function hideNode:insert(pos)
		if pos <= params.itemNum + 1 and  pos >= 1 then
			privateData.insertCell(pos)
			params.itemNum = params.itemNum + 1
		else
			tipLog("invalidPos: "..tostring(pos))
		end
	end

	--[[删除]]
	function hideNode:delete(pos)
		if pos <= params.itemNum and   pos >= 1 then
			privateData.deleteCell(pos)
			params.itemNum = params.itemNum - 1
		end
	end

	--[[更新]]
	function hideNode:update(pos)
		if pos <= params.itemNum and   pos >= 1 then
			privateData.updateItemCell(pos)
		end
	end
	--[[设置itemNum]]
	function hideNode:setTileNum(num)
		if type(num) == "number" then
			if num >= 0 then
				params.itemNum = num
				privateData.removeAllCell()
				privateData.update()
			end
		end
	end

	function hideNode:forceUpdate()
		if privateData then
			privateData.update()
		end
	end


	--[[获取itemNum]]
	function hideNode:getTileNum()
		return params.itemNum
	end

	--[[获取大小]]
	function hideNode:getSize()
		return privateData.getSize()
	end
	--[[获取显示的最小位置]]
	function hideNode:getMinViewPos()
		local minPos = -1
		for k, v in pairs(privateData.cell) do
			if minPos < 0  or  minPos > v._pos then
				minPos = v._pos
			end
		end

		return minPos
	end
	--[[获取显示的最大位置]]
	function hideNode:getMaxViewPos()
		local maxPos = -1
		for k, v in pairs(privateData.cell) do
			if  maxPos < v._pos then
				maxPos = v._pos
			end
		end

		return maxPos
	end
	--[[获取当前显示的所有位置]]
	function hideNode:getViewItemPos()
		local pos = {}
		for k, v in pairs(privateData.cell) do
			if not v._hide then
				table.insert(pos, v._pos)
			end
		end
		return pos
	end
	--[[创建删除动画]]
	function hideNode:applyDeleteAction(position)
		if privateData.isCellInShow(position) and privateData.getRowOrColCount() == 1 then
			if privateData.deletePos <= 0 or (privateData.deletePos > position) then
				privateData.deletePos = position
				privateData.deleteActionTime = 0
			end
		end
	end

	--[获取cell显示在第一个位置的offset]
	function hideNode:getCellOffset(position)
		local offset = cc.p(0, 0)
		if privateData.hasContent(position) then
			local vsize = params.rectNode:getContentSize()
			local testPos = cc.p(params.itemWidth / 2, vsize.height - params.itemHeight / 2)
			testPos = params.rectNode:convertToWorldSpace(testPos)
			testPos = hideNode:convertToNodeSpace(testPos)

			local pos = privateData.get2DPosByPos(position)
			if params.isVertical then
				offset.y = testPos.y - pos.y
			else
				offset.x = testPos.x - pos.x
			end
		end

		return offset
	end

	function hideNode:getNegCellOffset( position )
		local offset = cc.p(0, 0)
		if privateData.hasContent(position) then
			local vsize = params.rectNode:getContentSize()
			local testPos = cc.p(params.itemWidth / 2, params.itemHeight / 2)
			testPos = params.rectNode:convertToWorldSpace(testPos)
			testPos = hideNode:convertToNodeSpace(testPos)

			local pos = privateData.get2DPosByPos(position)
			if params.isVertical then
				offset.y = testPos.y - pos.y
			else
				offset.x = testPos.x - pos.x
			end
		end

		return offset
	end

	function hideNode:getTileInfo()
		return {itemRowGap = params.itemRowGap, itemColGap = params.itemColGap, itemWidth = params.itemWidth, itemHeight = params.itemHeight, rowCount = params.rowCount, colCount = params.colCount}
	end

	function hideNode:getPageSize()
		local colCount = params.colCount
		local rowGapCount = colCount -1
		rowGapCount = math.max(0, rowGapCount)
		local rowCount = params.rowCount
		local colGapCount = rowCount - 1
		colGapCount = math.max(0, colGapCount)

		return cc.size(colCount * params.itemWidth + rowGapCount * params.itemRowGap, rowCount * params.itemHeight + colGapCount * params.itemColGap)

	end

	function hideNode:getItemNumPerPage()
		return math.floor(params.colCount * params.rowCount)
	end

	function hideNode:setSelected(position, force)
		if type(position) == "number" then
			privateData.onSelectedChange(position, force)
		end

	end

	function hideNode:setTileLocalZOrder(position, number)
		if type(position) == "number" then
			local curCell = privateData.getCellByPos(position)
			if not curCell and privateData.hasContent(position) then
				curCell = privateData.newCell(position)
			end
			if curCell and curCell._node then
				curCell._node:setLocalZOrder(number)
			end
		end
	end

	privateData.init()

	return hideNode

end


TILELIST_DEFAULT_STYLE = {
	bgColorType = ccui.LayoutBackGroundColorType.none,
	bgColor = UI.COLOR_WHITE,
}
--[[
创建列表，列表的每项的索引值为1到n，也就是1到n的tile节点对应dataProvider的1到n的项
当在外部修改dataProvider的时候注意需要更新tileList可视区域的节点状态
@param	dataProvider	[table]		数据源(数组)
{
	{name = "a", pic="a.png"}, --这里的table可以是任意结构，其中每项的结构都相同,且key都是tileList的位置索引
	{name = "b", pic="b.png"}		--处理点击事件的时候需要有__isClick这个属性
}
@param itemTemplate	[function]	子项目创建模板，需返回一个显示对象，并且这个对象具有setState（dataProvider[pos]）方法
@param bounceable    [bool]     是否回弹，默认值true
@param itemRowGap      [number] 横向间距
@param itemColGap      [number] 纵向间距
@param colCount	      [number]	列数, 当direction == ccui.ListViewDirection.horizontal无效
@param rowCount        [number]   行数，当direction == ccui.ListViewDirection.vertical无效
@param itemHeight      [number]  item的高, 不传则默认为itemTemplate产生的高度
@param itemWidth       [number]  item的宽, 不传则默认为itemTemplate产生的宽度
@param direction		[number]	可拖动方向，取值[ccui.ListViewDirection], 默认ccui.ListViewDirection.vertical
@param height    	[number]	可视区域的高度, 当direction == ccui.ListViewDirection.horizontal无效 
@param width         [number]   可视区域的宽度，当direction == ccui.ListViewDirection.vertical无效 
@param padding       [{left, top, right, bottom}], padding
@params isOnChange   [bool]		true,一直返回onSelectedIndexChange,false,selectedPos和lastPos只有不相同时返回onSelectedIndexChange
								
@param isCancelState [bool]     是否支持点击取消状态，值为真的时候selectedPos和lastPos相同时返回onSelectedIndexChange（nil, nil, lastNode, lastPos），
								默认值为false
@param  style              [table]  样式
		style.bgColorType   [number]   背景类型，ccui.LayoutBackGroundColorType之一, 默认ccui.LayoutBackGroundColorType.none
		style.bgColor       [number]   背景颜色， UI.COLOR_WHITE等值，其中style.bgColorType不能为ccui.LayoutBackGroundColorType.none, 否则设置的值无效
		
@param  onSelectedIndexChange      [function(this, selectedNode, selectedPos, lastNode, lastPos)]选中回调函数，值不可能同时为nil但都可能为nil
									selecteNode: 	选中的节点， 可能为nil
									selectedPos：	选中的位置， 可能为nil
									lastNode： 		上次选中的节点，可能为nil
									lastPos： 		上次选中的位置，可能为nil
									node 可以包含_onCellClick({target, value})函数, 点击会触发节点的_onCellClick函数
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
    {
        SCROLL_TO_TOP, 
        SCROLL_TO_BOTTOM, 
        SCROLL_TO_LEFT, 
        SCROLL_TO_RIGHT, 
        SCROLLING, 
        BOUNCE_TOP, 
        BOUNCE_BOTTOM, 
        BOUNCE_LEFT, 
        BOUNCE_RIGHT, 
        CONTAINER_MOVED, 
		SCROLL_TO_TOP_EX, 
		SCROLL_TO_BOTTOM_EX, 
		SCROLL_TO_LEFT_EX, 
		SCROLL_TO_RIGHT_EX
};
@param  onSlideChange 		[function(this, eventName)]   只有bounceable为ture时才会触发
@param  offsetDistance 		距离顶部、底部、左边、右边有多远才触发
]]

function newTileList(params)
	local function warnLog(str)
		print("newTileList warning: "..str)
	end

	params = params or {}
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
	privateData.onSlideChange = params.onSlideChange
	privateData.isCancelState = params.isCancelState or false
	privateData.isOnChange = params.isCancelState or params.isOnChange or false

	local function getLastSelectedValue (referrencePos)
		local dp = tilelist:getDataProvider()
		referrencePos = referrencePos or 1
		for i = referrencePos, 1, -1 do
			if type(dp[i]) == "table" and rawget(dp[i],"__isClick") then
				return dp[i], tilelist:getNode(i), i
			end
		end
		for i = referrencePos + 1, #dp do
			if type(dp[i]) == "table" and rawget(dp[i],"__isClick") then
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
		warnLog("onRollIn: "..tostring(pos ).." count: "..tostring(tilelist:getChildrenCount()))
		--pos默认从0开始计数

		privateData.viewNode[pos] = node
		local minPos = tilelist:getMinViewPos()
		local maxPos = tilelist:getMaxViewPos()
		local invalidPos = {}
		for k, v in pairs(privateData.viewNode) do
			if k < minPos or k > maxPos then
				privateData.viewNode[k] = nil
			end
		end

		local v = privateData.dataProvider[pos]
		if v and type(node.setState) == "function" then
			node:setState(v, pos)
		end

		-- if privateData.__onRollIn then
		--    privateData.__onRollIn(node, pos)
		-- else
		-- 	local v = privateData.__dataProvider[pos]
		-- 	if v and type(node.setState) == "function" then
		-- 	    node:setState(v, pos)
		-- 	end
		-- end
	end
	local onSelected = function (selectedNode, selectedPos, lastNode, lastPos, force)
		if privateData.onSelectedIndexChange then
			local selectedValue = tilelist:getDataProvider()[selectedPos]
			local lastValue = nil
			lastValue, lastNode, lastPos = getLastSelectedValue(lastPos)
			if privateData.isOnChange then
				if privateData.isCancelState then
					if selectedNode == lastNode then
						if type(selectedValue) == "table" and rawget(selectedValue,"__isClick") then
							selectedPos, selectedNode, selectedValue = nil, nil, nil
						else
							lastPos, lastNode, lastValue = nil, nil, nil
						end
	
					end
				end
			else
				if selectedNode == lastNode and type(selectedValue) == "table" and rawget(selectedValue,"__isClick") then
					if force then
						lastPos, lastNode, lastValue = nil, nil, nil
					else
						selectedPos, selectedNode, lastPos, lastNode = nil, nil, nil, nil
					end

				end
			end
			
			if selectedPos or lastPos then
				if type(lastValue) == "table" then
					rawset(lastValue, "__isClick", false)
				end
				if type(selectedValue) == "table" then
					rawset(selectedValue, "__isClick", true)
				end
				privateData.onSelectedIndexChange(tilelist, selectedNode, selectedPos, lastNode, lastPos)
				if selectedValue then
					if selectedNode then
						if type(selectedNode._onCellClick) == "function" then
							selectedNode:_onCellClick({
								value = selectedValue,
								target = tilelist,
								pos = selectedPos,
								force = force,
							})
						end
					end
				end
				if lastValue then
					if lastNode then
						if type(lastNode._onCellClick) == "function" then
							lastNode:_onCellClick({
								value = lastValue,
								target = tilelist,
								pos = lastPos,
								force = force,
							})
						end
					end
				end

			end
		else
			warnLog("privateData.onSelectedIndexChange is nil")

		end
	end

	local tilenum = getTableCount(privateData.dataProvider)

	local padding = params.padding or {}
	padding.left = padding.left or 0
	padding.right = padding.right or 0
	padding.top = padding.top or 0
	padding.bottom = padding.bottom or 0
	local  direction = params.direction or ccui.ListViewDirection.vertical
	local  viewS = cc.size(params.width or 200, params.height or 200)
	local isVertical = (direction == ccui.ListViewDirection.vertical)
	local viewSInit = true
	tilelist = UI.newScrollView({
		width = viewS.width,
		height = viewS.height,
		x = params.x, y = params.y,
		anchorPoint = params.anchorPoint,
		bounceEnabled = (nil == params.bounceEnabled) and true or params.bounceEnabled,
		direction = direction,
		style = params.style,
	})
	local hideNode = UI.newAutoHideNode({
		itemNum = tilenum,
		x = padding.left,
		y = padding.bottom,
		isForce = params.isForce,
		isReverseZOrder = params.isReverseZOrder,
		isVertical = (direction == ccui.ListViewDirection.vertical),
		itemColGap = params.itemColGap,
		itemRowGap = params.itemRowGap,
		colCount = params.colCount,
		rowCount = params.rowCount,
		rectNode = tilelist,
		itemWidth = params.itemWidth,
		itemHeight = params.itemHeight,
		itemTemplate = params.itemTemplate,
		itemTemplateParams = params.itemTemplateParams,
		swallowTouches = params.swallowTouches,
		onTouch = params.onTouch,
		onItemNumChange = function (sender, itemNum)
			local size = sender:getSize()
			if viewSInit then
				viewSInit = false
				if direction == ccui.ListViewDirection.vertical then

					tilelist:setContentSize(cc.size(size.width + (padding.left + padding.right), viewS.height))
				else
					tilelist:setContentSize(cc.size(viewS.width, size.height + (padding.top + padding.bottom)))
				end
				viewS = tilelist:getContentSize()
			end

			tilelist:setInnerContainerSize(cc.size(size.width + (padding.left + padding.right), size.height + (padding.top + padding.bottom)))
			if isVertical  then
				local innerContainerS = tilelist:getInnerContainerSize()
				local offsetY = innerContainerS.height - padding.top - size.height
				--这里需要平移
				local pos = cc.p(sender:getPosition())
				pos.y = offsetY
				sender:setPosition(pos)
			end
		end,
		onRollIn = function (sender, node, pos)
			onRollIn(node, pos)
		end,
		onRollOut = function (sender, pos)

		end,
		onSelected = onSelected,
		onUpdate = params.onUpdate,
	})

	if privateData.onSlideChange then
		local nameTable = {
			"SCROLL_TO_TOP",
			"SCROLL_TO_BOTTOM",
			"SCROLL_TO_LEFT",
			"SCROLL_TO_RIGHT",
			"SCROLLING",
			"BOUNCE_TOP",
			"BOUNCE_BOTTOM",
			"BOUNCE_LEFT",
			"BOUNCE_RIGHT",
			"CONTAINER_MOVED",
		-- "SCROLLVIEW_EVENT_AUTOSCROLL_ENDED", -- cocos2dx3.13.1
		-- "SCROLL_TO_TOP_EX", --  add
		-- "SCROLL_TO_BOTTOM_EX", -- add
		-- "SCROLL_TO_LEFT_EX", -- add
		-- "SCROLL_TO_RIGHT_EX" -- add
		}

		local topScrolling = false
		local topOnce = false
		local bottomScrolling = false
		local bottomOnce = false
		tilelist:addEventListener(function(sender, eventType)
			if eventType < #nameTable then
				local name = nameTable[eventType + 1]
				privateData.onSlideChange(sender, name)
				if params.offsetDistance and params.offsetDistance > 0 then
					if name == "SCROLL_TO_TOP" then
						local iy = sender:getInnerContainerPosition().y
						local ih = sender:getInnerContainerSize().height
						local vh = sender:getContentSize().height
						topOnce = topOnce or (-(iy + ih - vh) > params.offsetDistance)
						topScrolling = true
					elseif name == "SCROLL_TO_BOTTOM" then
						local iy = sender:getInnerContainerPosition().y
						bottomOnce = bottomOnce or iy > params.offsetDistance
						bottomScrolling = true
					end

					if name == "BOUNCE_TOP" then
						if topOnce and not topScrolling then
							topOnce = false
							privateData.onSlideChange(sender, "SCROLL_TO_TOP_EX")
						end
						topScrolling = false
					end

					if name == "BOUNCE_BOTTOM" then
						if bottomOnce and not bottomScrolling then
							bottomOnce = false
							privateData.onSlideChange(sender, "SCROLL_TO_BOTTOM_EX")
						end
						bottomScrolling = false
					end
				end
			end
		end)
	end

	--[[删除操作，重新摆放受影响的节点位置，外部不直接使用]]
	function tilelist:deleteTile(position, isAction)
		hideNode:delete(position)
		if isAction then
			hideNode:applyDeleteAction(position)
		end
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
	function tilelist:updateAllItem()
		local b = self:getMinViewPos()
		local e = self:getMaxViewPos()
		for i = b, e do
			hideNode:update(i)
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

	--[[
	设置显示区域最小的显示位置，可控制从第几列或第几行开始显示，
	例：tileList布局为：
		0 1 2
		3 4 5
		6 7 8
		。。。
		position的值为0， 1， 2则表示从第一行开始显示，以此类推，纵向的原理一样
	]]
	function tilelist:setMinViewPos(position,scrollTime)

		local offset = hideNode:getCellOffset(position)
		local innerContainer = tilelist:getInnerContainer()
		local pos = cc.p(innerContainer:getPosition())
		local tarPos = cc.pAdd(pos, offset)
		local innerS = tilelist:getInnerContainerSize()
		tarPos.y = math.min(0, tarPos.y)
		tarPos.x = math.min(0, tarPos.x)
		if isVertical then
			
			tarPos.y = math.max(-innerS.height + viewS.height, tarPos.y)
			if (-innerS.height + viewS.height) ~= 0 then
				local per = (1 - tarPos.y / (-innerS.height + viewS.height)) * 100
				if scrollTime then
					tilelist:scrollToPercentVertical(per,scrollTime,true)
				else
					tilelist:jumpToPercentVertical(per)
				end
			else
				if scrollTime then
					tilelist:scrollToPercentVertical(100,scrollTime,true)
				else
					tilelist:jumpToPercentVertical(100)
				end
			end
		else
			tarPos.x = math.min(innerS.width - viewS.width, math.abs(tarPos.x))
			if -innerS.width + viewS.width ~= 0 then
				local per = (tarPos.x / (innerS.width - viewS.width)) * 100
				if scrollTime then
					tilelist:scrollToPercentHorizontal(per,scrollTime,true)
				else
					tilelist:jumpToPercentHorizontal(per)
				end
			else
				if scrollTime then
					tilelist:scrollToPercentHorizontal(100,scrollTime,true)
				else
					tilelist:jumpToPercentHorizontal(100)
				end
			end

		end
		--强制更新一下
		hideNode:forceUpdate()
	end

	function tilelist:setTargetInBottom( position )
		local offset = hideNode:getNegCellOffset(position)
		local innerContainer = tilelist:getInnerContainer()
		local pos = cc.p(innerContainer:getPosition())
		local tarPos = cc.pAdd(pos, offset)
		local innerS = tilelist:getInnerContainerSize()
		tarPos.y = math.min(0, tarPos.y)
		tarPos.x = math.min(0, tarPos.x)
		if isVertical then

			tarPos.y = math.max(-innerS.height + viewS.height, tarPos.y)
			if (-innerS.height + viewS.height) ~= 0 then
				tilelist:jumpToPercentVertical((1 - tarPos.y / (-innerS.height + viewS.height)) * 100)
			else
				tilelist:jumpToPercentVertical(100)
			end

			--tilelist:jumpToPercentVertical(100)
		else

			tarPos.x = math.min(innerS.width - viewS.width, math.abs(tarPos.x))
			if -innerS.width + viewS.width ~= 0 then
				tilelist:jumpToPercentHorizontal((tarPos.x / (innerS.width - viewS.width)) * 100)
			else
				tilelist:jumpToPercentHorizontal(100)
			end

		end
		--强制更新一下
		hideNode:forceUpdate()
	end

	function tilelist:getTileNum()
		return hideNode:getTileNum()
	end

	function tilelist:setTileNum(num)
		hideNode:setTileNum(num)
	end

	local function checkValid(self)
		if self:getTileNum() ~= #privateData.dataProvider then
			warnLog("self:getTileNum() ~= #privateData.dataProvider "..tostring(self:getTileNum()).." "..tostring(#privateData.dataProvider))
			return false
		end
		return true
	end

	--扩展api,这里除了get方法之外，其他方法都会更新可视区域的节点，所以修改dataProrider的时候应该注意更新节点带来的效率损失

	--[[设置dataProvider
	--@param dataProvider [table]数据源，格式需要与规定的格式一致
	]]
	function tilelist:setDataProvider(dataProvider, clearClick)
		if params.fillRow then
			local fillRow = params.fillRow
			local colCount = params.colCount or 1
			local fillCount = colCount or 0
			local dataCount = #dataProvider

			local needFill = 0

			if dataCount > colCount * fillRow then
				needFill = fillCount - (dataCount%fillCount)
				needFill = needFill % fillCount
			else
				needFill = colCount * fillRow - dataCount
			end
			-- local fillCount = colCount or 0
			-- local needFill = fillCount - (dataCount%fillCount)
			-- if math.floor(dataCount/colCount)<params.fillRow-1 then
			-- 	needFill = needFill + (params.fillRow-1 - math.floor(dataCount/colCount))*colCount
			-- end
			-- needFill = needFill%fillCount
			for i = 1, needFill do
				table.insert(dataProvider, {})
			end
		end
		if type(dataProvider) == "table" then
			if dataProvider.__cname == "TileListData" then
				dataProvider:addTileList(self)
			else
				if clearClick then
					for k, v in pairs(dataProvider) do
						rawset(v, "__isClick", false)
					end
				end
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
					table.remove(privateData.dataProvider, position)
					self:deleteTile(position)
					if isAction then
						hideNode:applyDeleteAction(position)
					end

				else
					warnLog("self.__dataProvider[position] is nil.. "..tostring(position))
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
	function tilelist:appendDatas(datas)
		for i, v in ipairs(datas) do
			table.insert(privateData.dataProvider, v)
		end
		self:setTileNum(getTableCount(privateData.dataProvider))
	end

	function tilelist:getViewItemPos()
		return hideNode:getViewItemPos()
	end

	function tilelist:getHideNode()
		return hideNode
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

	function tilelist:setSelected(position, force)
		hideNode:setSelected(position, force)
	end

	function tilelist:setTileLocalZOrder( position, number )
		hideNode:setTileLocalZOrder(position, number)
	end

	function tilelist:getLastSelectedValue()
		return getLastSelectedValue()
	end

	function tilelist:getRealSize()
		return hideNode:getSize()
	end

	function tilelist:getPercent()
		local innerContainer = tilelist:getInnerContainer()
		local pos = cc.p(innerContainer:getPosition())
		local tarPos = pos
		local innerS = tilelist:getInnerContainerSize()
		if isVertical then

			tarPos.y = math.max(-innerS.height + viewS.height, tarPos.y)
			return (1 - tarPos.y / (-innerS.height + viewS.height)) * 100
		else

			tarPos.x = math.min(innerS.width - viewS.width, math.abs(tarPos.x))
			return (tarPos.x / (innerS.width - viewS.width)) * 100

		end
	end

	function tilelist:selectNone( pos )
		if privateData.onSelectedIndexChange then
			local lastValue, lastNode, lastPos = getLastSelectedValue()
			privateData.onSelectedIndexChange(nil, nil, pos, lastNode, lastPos)
			privateData.lastClickCell = nil
			if lastValue then
				rawset(lastValue,"__isClick",false)
			end
		end
	end

	--屏蔽
	privateData.registerRollInHandler = tilelist.registerRollInHandler
	tilelist.registerRollInHandler = nil
	privateData.registerSelectedHandler = tilelist.registerSelectedHandler
	tilelist.registerSelectedHandler = nil

	tilelist:setDataProvider(params.dataProvider or {})

	if params.scissor then
		tilelist:setClippingType(ccui.ClippingType.SCISSOR)
	end

	return tilelist
end

--tilelistData
TileListData = class("TileListData")

function TileListData:ctor()
	self._data = {}
	self._tileList = {}
end

--外部接口
function TileListData:addTileList(list)
	if tolua.cast(list, "cc.Node") then
		self._tileList[list] = list
		if  list.setDataProvider then
			list:setDataProvider(self._data)
		end
	end
end
function TileListData:count()
	return #self._data
end


function TileListData:insert(value, position)
	if position and position <= #self._data + 1 then
		table.insert(self._data, position, value)
	else
		table.insert(self._data, value)
		position = #self._data
	end
	table.walk(self._tileList, function (k, v)
		if tolua.cast(v, "cc.Node")  and  v.insertTile then
			v:insertTile(position)
		else
			self._tileList[k] = nil
		end
	end)
end

function TileListData:delete(position, isAction)
	if position <= #self._data then
		table.remove(self._data, position)
		table.walk(self._tileList, function (k, v)
			if tolua.cast(v, "cc.Node")  and  v.deleteTile then
				v:deleteTile(position, isAction)
			else
				self._tileList[k] = nil
			end
		end)
	end
end


function TileListData:update(value, position, fun)
	if position  and  position <= #self._data and position >= 1 then
		if fun then
			fun(self._data[position], value)
		else
			self._data[position] = value
		end

	elseif #self._data >= 1 then
		if fun then
			fun(self._data[#self._data], value)
		else
			self._data[#self._data] = value
		end

		position = #self._data
	else
	-- print(168, "error pos: ", tostring(position))
	end
	table.walk(self._tileList, function (k, v)
		if tolua.cast(v, "cc.Node") and v.updateTile then
			v:updateTile(position)
		else
			self._tileList[k] = nil
		end
	end)
end

function TileListData:setData(value)
	if type(value) == "table" then
		self._data = value
	end
	table.walk(self._tileList, function (k, v)
		if tolua.cast(v, "cc.Node") and v.setDataProvider then
			v:setDataProvider(self._data)
		else
			self._tileList[k] = nil
		end
	end)
end

function TileListData:getData()
	return self._data
end

function TileListData:setMinViewPos(position)
	if position  and  position <= #self._data and position >= 1 then
		table.walk(self._tileList, function (k, v)
			if not tolua.isnull(v) then
				v:setMinViewPos(position)
			else
				self._tileList[k] = nil
			end
		end)
	else
	-- print(168, "error pos: ", tostring(position))
	end
end
