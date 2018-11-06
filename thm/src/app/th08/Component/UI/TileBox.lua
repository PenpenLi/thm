module("UI", package.seeall)
--[[
@param	x				[number]	x坐标
@param	y				[number]	y坐标
@param	width			[number]	宽度
@param	height			[number]	高度
@param	anchorPoint		[cc.p]		锚点(如UI.POINT_CENTER)
@param	margin  		[number]	item之间的间隔
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
function newTileBox(params)
    params = params or {}

    local privateData = {}
    privateData.dataProvider = {}
    privateData.viewNode = {}
	privateData.onSelectedIndexChange = params.onSelectedIndexChange
	-- privateData.selectedState = {}   --保存各个位置的选中状态
	privateData.isCancelState = params.isCancelState or false
	privateData.isOnChange = params.isCancelState or params.isOnChange or false

    local box = THSTG.UI.newVBox(params)

    --用于判断点击
    local lastNode = nil
    local lastPos = nil
    local function onChange(node,pos)

        if privateData.isOnChange then
            if privateData.isCancelState then
                if node == lastNode then
                    node, pos = nil, nil
                end
            end
        end

        if pos or lastPos then
            if privateData.onSelectedIndexChange then
                return privateData.onSelectedIndexChange(box,node,pos,lastNode,lastPos)
            end
        end

        lastNode = node
        lastPos = pos
    end

    function box:getDataProvider()
        return privateData.dataProvider
    end

    function box:setDataProvider(dataProvider, clearClick)
        self:removeAllChildren()
        
        for i,v in ipairs(dataProvider) do
            if params.itemTemplate then
                local item = params.itemTemplate(params.itemTemplateParams)
                
                if item then
                    item:setState(v,i)
                    self:addChild(item)
                end
            end
        end
        self:forceDoLayout()
        privateData.dataProvider = dataProvider
    end
    
    local oldAddChild = box.addChild
    function box:addChild(item)
        local pos = #privateData.viewNode + 1
        local node = UI.newWidget({
            width = item:getContentSize().width,
            height = item:getContentSize().height,
            onClick = function (sender)
                return onChange(item,pos)
            end,
        })
        node:addChild(item)
        privateData.viewNode[pos] = item
        oldAddChild(self,node)
    end


    local oldRemoveAllChildren = box.removeAllChildren
    function node:removeAllChildren()
        oldRemoveAllChildren(self)
        privateData.viewNode = {}
    end


    function box:setSelected(index)
        --TODO:设置选择
        onChange(privateData.privateData.viewNode[index],index)
    end

    return box
end