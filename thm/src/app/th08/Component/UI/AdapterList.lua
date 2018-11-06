module("UI", package.seeall)

--[[
--生成垂直列表
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
@params  colCount    		[number]  列数    
@params  rowCount 			[number]  行数
@params  itemColGap         [number]  纵列节点间的间隔
@params  itemRowGap         [number]  横排节点间的间隔
@param   direction		[number]	可拖动方向，取值[ccui.ListViewDirection], 默认ccui.ListViewDirection.vertical
@param	autoSize		[boolean]	自适应大小
@param	linearGravity	[ccui.LinearGravity]	对齐方式，请参考ccui.LinearGravity枚举[top, centerVertical, bottom]
@param  itemTemplate	[function]	子项目创建模板，需返回一个显示对象，并且这个对象具有setState（dataProvider[pos]）方法
@params  itemTemplateParams [any]       模块参数
@params isOnChange   [bool]		true,一直返回onSelectedIndexChange,false,selectedPos和lastPos只有不相同时返回onSelectedIndexChange
								
@param isCancelState [bool]     是否支持点击取消状态，值为真的时候selectedPos和lastPos相同时返回onSelectedIndexChange（nil, nil, lastNode, lastPos），
                                默认值为false
                                
@param  onSelectedIndexChange      [function(this, selectedNode, selectedPos, lastNode, lastPos)]选中回调函数，值不可能同时为nil但都可能为nil
                                    selecteNode: 	选中的节点， 可能为nil
                                    selectedPos：	选中的位置， 可能为nil
                                    lastNode： 		上次选中的节点，可能为nil
                                    lastPos： 		上次选中的位置，可能为nil
                                    node 可以包含_onCellClick({target, value})函数, 点击会触发节点的_onCellClick函数
]]
function newAdapterList(params)
    assert(params == nil or type(params) == "table", "[UI] newAdapterList() invalid params")
    ---
    local privateData = {}
    privateData.viewNodes = {}
    privateData.dataProvider = {}
    privateData.isCancelState = params.isCancelState or false
    privateData.isOnChange = params.isCancelState or params.isOnChange or false
    privateData.onSelectedIndexChange = params.onSelectedIndexChange
    privateData.direction = params.direction
    privateData.itemColGap = params.itemColGap or 0
    privateData.itemRowGap = params.itemRowGap or 0
    privateData.colCount = params.colCount or 1
    privateData.rowCount = params.rowCount or 1

    privateData.x = params.x or 0
    privateData.y = params.y or 0
    privateData.width = params.width or nil
    privateData.height = params.height or nil
    privateData.anchorPoint = params.anchorPoint or THSTG.UI.POINT_CENTER
    -----View------
    local node = THSTG.UI.newNode({
        x = privateData.x,
        y = privateData.y,
        width = privateData.width,
        height = privateData.height,
        anchorPoint = privateData.anchorPoint
    })
    ---
    --用于判断点击
    local lastNode = nil
    local lastPos = nil
    local function onChange(curNode,curPos)
        if privateData.onSelectedIndexChange then
            
            local selectedValue = node:getDataProvider()[curPos]
            local lastValue = lastPos ~= nil and node:getDataProvider()[lastPos] or nil

            if privateData.isOnChange then
                if privateData.isCancelState then
                    if curNode == lastNode then
                        curNode, curPos = nil, nil
                    end
                end
            end
            if curPos or lastPos then
                if type(lastValue) == "table" then
                    rawset(lastValue, "__isClick", false)
                end
                if type(selectedValue) == "table" then
                    rawset(selectedValue, "__isClick", true)
                end
                if curNode then
                    if type(curNode._onCellClick) == "function" then
                        curNode:_onCellClick({
								value = selectedValue,
								target = node,
								pos = curPos,
								-- force = force,
							})
                    end
                end
                if lastNode then
                    if type(lastNode._onCellClick) == "function" then
                        lastNode:_onCellClick({
                            value = lastValue,
                            target = node,
                            pos = lastPos,
                            -- force = force,
                        })
                    end
                end

                if privateData.onSelectedIndexChange then
                    privateData.onSelectedIndexChange(node,curNode,curPos,lastNode,lastPos)
                end
            end
        end
        lastNode = curNode
        lastPos = curPos
    end

    function node:setDataProvider(dataProvider, clearClick)
        assert(params.itemTemplate and type(params.itemTemplate) == "function" , "[UI] newAdapterList() invalid itemTemplate")

        privateData.dataProvider = dataProvider or {}
        self:removeAllChildren()
       
        for i,v in ipairs(privateData.dataProvider) do
            local item = params.itemTemplate()
            if item then
                if type(item.setState) == "function" then
                    item:setState(v,i)
                end
                self:addChild(item)
            end
        end
       
    end

    function node:getDataProvider(index)
        return privateData.dataProvider
    end

    local oldAddChild = node.addChild
    function node:addChild(item)
        --TODO:位置调整x,y
        local itemWidth = item:getContentSize().width
        local itemHeight = item:getContentSize().height
        local index = #privateData.viewNodes + 1
        local posX = node:getPositionX() 
        local posY = node:getPositionY() 
        local topPosY = (1.0 - privateData.anchorPoint.y) * privateData.height  + posY
        if privateData.direction == ccui.ListViewDirection.vertical then
            posY = node:getPositionY() - (index * itemHeight + privateData.itemColGap)  --因为绘图起点在左下角缘故
        else
            posX = index * itemWidth + privateData.itemRowGap
        end

        local node = UI.newWidget({
            x = posX,
            y = posY,
            width = itemWidth,
            height = itemHeight,
            anchorPoint = THSTG.UI.POINT_CENTER,
            onClick = function (sender)
                return onChange(item,index)
            end,
        })

        item:setPositionX(itemWidth/2)
        item:setPositionY(itemHeight/2)
        item:setAnchorPoint(THSTG.UI.POINT_CENTER)
        node:addChild(item)
        privateData.viewNodes[index] = item
        oldAddChild(self,node)
    end

    local oldRemoveAllChildren = node.removeAllChildren
    function node:removeAllChildren()
        oldRemoveAllChildren(self)
        privateData.viewNodes = {}
    end
    
    function node:setSelected(index)
        if index <= #privateData.viewNodes then
            onChange(privateData.viewNodes[index],index)
        end
    end

    return node
end