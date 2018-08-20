module("THSTG.UI", package.seeall)

--默认参数
BOX_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
	margin = 0,
	autoSize = false,
	linearGravity = ccui.LinearGravity.left
}

--[[
水平布局
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
@param	margin  		[number]	item之间的间隔
@param	autoSize		[boolean]	自适应大小
@param	linearGravity	[ccui.LinearGravity]	对齐方式，请参考ccui.LinearGravity枚举[top, centerVertical, bottom]
]]
function newHBox(params)
	params = params or {}
	assert(params == nil or type(params) == "table", "[UI] newHBox() invalid params")

	local finalParams = clone(BOX_DEFAULT_PARAMS)
	finalParams.linearGravity = ccui.LinearGravity.top
	THSTG.TableUtil.mergeA2B(params, finalParams)

	local box = ccui.HBox:create()
	box:setPosition(finalParams.x, finalParams.y)
	box:setAnchorPoint(finalParams.anchorPoint)
	if finalParams.width > 0 and finalParams.height > 0 then
		box:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	if finalParams.autoSize then
		box:setAutoSize(true)
	end

	local addChild = box.addChild
	function box:addChild(child, ...)
		if finalParams.margin then
			if  tolua.iskindof(child, "ccui.Widget") then
				local layoutParameter = ccui.LinearLayoutParameter:create()
				layoutParameter:setGravity(finalParams.linearGravity)
				layoutParameter:setMargin({left = 0, top = 0, right = finalParams.margin, bottom = 0})
				child:setLayoutParameter(layoutParameter)
			end
		end
		addChild(box, child, ...)
	end

	function box:addLayoutChild(child, layoutParams, ...)
		if tolua.iskindof(child, "ccui.Widget") then
			if not layoutParams then
				box:addChild(child, ...)
				return
			end
			if layoutParams then
				local layoutParameter = ccui.LinearLayoutParameter:create()
				layoutParameter:setGravity(layoutParams.linearGravity or  finalParams.linearGravity)
				local margin = {left = 0, top = 0, right = 0, bottom = 0}
				THSTG.TableUtil.mergeA2B(layoutParams.margin, margin)
				layoutParameter:setMargin(margin)
				child:setLayoutParameter(layoutParameter)
			end
		end
		addChild(box, child, ...)
	end

	return box
end

--[[
垂直布局
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
@param	margin  		[number]	item之间的间隔
@param	autoSize		[boolean]	自适应大小
@param	linearGravity	[ccui.LinearGravity]	对齐方式，请参考ccui.LinearGravity枚举[left, centerHorizontal, right]
]]
function newVBox(params)
	params = params or {}
	assert(params == nil or type(params) == "table", "[UI] newVBox() invalid params")

	local finalParams = clone(BOX_DEFAULT_PARAMS)
	THSTG.TableUtil.mergeA2B(params, finalParams)

	local box = ccui.VBox:create()
	box:setPosition(finalParams.x, finalParams.y)
	box:setAnchorPoint(finalParams.anchorPoint)
	if finalParams.width > 0 and finalParams.height > 0 then
		box:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	if finalParams.autoSize then
		box:setAutoSize(true)
	end

	local addChild = box.addChild
	function box:addChild(child, ...)
		if finalParams.margin then
			if tolua.iskindof(child, "ccui.Widget") then
				local layoutParameter = ccui.LinearLayoutParameter:create()
				layoutParameter:setGravity(finalParams.linearGravity)
				layoutParameter:setMargin({left = 0, top = 0, right = 0, bottom = finalParams.margin})
				child:setLayoutParameter(layoutParameter)
			end
		end
		addChild(box, child, ...)
	end

	function box:addLayoutChild(child, layoutParams, ...)
		if tolua.iskindof(child, "ccui.Widget") then
			if not layoutParams then
				box:addChild(child, ...)
				return
			end
			if layoutParams then
				local layoutParameter = ccui.LinearLayoutParameter:create()
				layoutParameter:setGravity(layoutParams.linearGravity or finalParams.linearGravity)
				local margin = {left = 0, top = 0, right = 0, bottom = 0}
				THSTG.TableUtil.mergeA2B(layoutParams.margin, margin)
				layoutParameter:setMargin(margin)
				child:setLayoutParameter(layoutParameter)
				--printTable(168, layoutParams)
			end
		end
		addChild(box, child, ...)
	end
	return box
end

--[[
多行, 不支持删除操作
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	col			[number]	列数
@param	xGap			[number]	列间距
@param	yGap			[number]	行间距
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
@param	linearGravity	[ccui.LinearGravity]	每行对齐方式
@param	linearGravity2	[ccui.LinearGravity]	每列对齐方式，请参考ccui.LinearGravity枚举[left, centerHorizontal, right]
]]
function newMultiHBox(params)
	params = params or {}
	local col = tonumber(params.col) and params.col or 1
	local yGap = params.yGap or 0
	local xGap = params.xGap or 8
	local node = THSTG.UI.newVBox({
		autoSize = true,
		anchorPoint = params.anchorPoint,
		x = params.x, y = params.y,
		linearGravity = params.linearGravity,
		margin = yGap,
	})

	local addChild = node.addChild
	local childNum, curBox = 0
	local childList = {}
	local boxList={}
	function node:addChild(child)
		local row = math.ceil(childNum / col)
		if not curBox or row ~= math.ceil((childNum + 1) / col) then
			curBox = THSTG.UI.newHBox({
				autoSize = true,
				linearGravity = params.linearGravity2,
				margin = xGap,
			})
			addChild(node, curBox)
			table.insert(boxList,curBox)
		end
		curBox:addChild(child)
		childNum = childNum + 1
		table.insert(childList, child)
		curBox:forceDoLayout()
		node:forceDoLayout()
	end

	function node:getChildren()
		return childList
	end

	function node:removeAllChildrenForce( ... )
		for _,box in ipairs(boxList)do
			box:removeFromParent()
		end

		childNum=0
		curBox=false
		childList={}
		boxList={}
		node:forceDoLayout()
	end

	return node
end
