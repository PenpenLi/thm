module("UI", package.seeall)

--[[
创建用于提供给TabBar使用的层容器
@param	#table		layers		数据源
{
	{data = "Label1", callback = A.create, callbackParams = {a = 10, b = 20}}, 
	{data = "Label2", callback = B.create, callbackParams = {a = 10, b = 20}}, 
	{data = {normal = cc.Node:create(), selected = cc.Node:create(), disabled = cc.Node:create()}, callback = C.create, callbackParams = {c = "aasdf", d = 12}}, 
}
@return	返回cc.Node对象

@example
	local win = UI.newWindow()
	local FRButtonTest = require "MainGame.Module.UITest.Tests.FRButtonTest"
	local FRLabelTest = require "MainGame.Module.UITest.Tests.FRLabelTest"
	local FRWindowTest = require "MainGame.Module.UITest.Tests.FRWindowTest"
	local FRBoxTest = require "MainGame.Module.UITest.Tests.FRBoxTest"
	
	local FRScrollViewTest = require "MainGame.Module.UITest.Tests.FRScrollViewTest"
	local FRImageTest = require "MainGame.Module.UITest.Tests.FRImageTest"
	
	local ls = UI.newLayerStack({
		x = 5, y = 5, 
		layers = {
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
			{data = "label", creator = ButtonTest.create, creatorParams = {a = 11}}, 
}
})
	win:addChild(ls)
]]

function newLayerStack(params)
	assert(type(params) == "table", "[UI] newLayerStack() invalid params")
	assert(type(params.layers) == "table", "[UI] newLayerStack() invalid params.layers")

	local x, y = params.x or 0, params.y or 0

	local ls = cc.Node:create()
	ls:setPosition(x, y)

	--子层对象
	local children = {}
	--当前选择的层索引, 上次选择的层索引
	local selectedIndex, prevSelectedIndex = 0, 0

	--初始化所有子对象数组为false值，方便后面插入删除层
	for k, v in ipairs(params.layers) do
		children[k] = false
	end

	--转换成可供TabBar使用的数据
	function ls:toDataProvider()
		local dp = {}
		for k, v in ipairs(params.layers) do
			table.insert(dp, v.data)
		end
		return dp
	end

	function ls:getLayerDataAtIndex(index)
		return params.layers[index]
	end

	function ls:getSelectedIndex() return selectedIndex end
	function ls:getSelectedLayer()
		return children[selectedIndex]
	end
	function ls:getLayerAtIndex(index)
		return children[index]
	end
	local function keyToIndex(key)
		if not key then return end
		for k, v in ipairs(params.layers) do
			if type(v) == "table" and v.layerKey == key then
				return k
			end
		end
	end
	function ls:setSelectedIndex(value)
		if type(value) == "string" then
			value = keyToIndex(value)
		end
		if not value then return end
		if value < 1 then
			value = 1
		elseif value > #params.layers then
			value = #params.layers
		end

		if selectedIndex ~= value then
			prevSelectedIndex = selectedIndex
			selectedIndex = value

			local prevNode = children[prevSelectedIndex]
			if prevNode and prevNode:getParent() then
				--这里必须调用这个并且传入false
				-- prevNode:removeFromParent()
				prevNode:removeFromParentAndCleanup(false)
			end

			local node = children[selectedIndex]
			if not node then
				local layerData = params.layers[selectedIndex]
				node = layerData.creator(layerData.creatorParams)
				assert(node ~= nil, "[UI] LayerStack.setSelectedIndex layer data's creator must return a cc.Node!")
				children[selectedIndex] = node
				node:retain()
			end
			self:addChild(node)
		end
	end
	function ls:setSelectedIndexByKey(key)
		local k = keyToIndex(key)
		if k then
			ls:setSelectedIndex(k)
		end
	end
	function ls:getLayerByKey(key)
		local k = keyToIndex(key)
		return k and children[k]
	end

	--更新层数据
	function ls:updateLayerData(layerIndex, layerData)
		assert(layerIndex >= 1 and layerIndex <= #params.layers, "[UI] LayerStack.updateLayerData layerIndex must >= 1 and <=#params.layers")
		assert(type(layerData) == "table", "[UI] LayerStack.updateLayerData layerData must be a table")

		params.layers[layerIndex] = layerData
		if selectedIndex == layerIndex then
			local node = children[selectedIndex]
			if node then
				node:release()
				node:removeFromParent()
			end

			node = layerData.creator(layerData.creatorParams)
			assert(node ~= nil, "[UI] LayerStack.updateLayerData layer data's creator must return a cc.Node!")
			children[selectedIndex] = node
			node:retain()
			self:addChild(node)
		end
	end

	--插入层数据
	function ls:insertLayerData(layerIndex, layerData)
		assert(layerIndex >= 1 and layerIndex <= #params.layers + 1, "[UI] LayerStack.insertLayerData layerIndex must >= 1 and <=#params.layers+1")
		assert(type(layerData) == "table", "[UI] LayerStack.insertLayerData layerData must be a table")

		table.insert(params.layers, layerIndex, layerData)
		if selectedIndex == layerIndex then
			local node = children[selectedIndex]
			if node then
				node:release()
				node:removeFromParent()
			end

			node = layerData.creator(layerData.creatorParams)
			assert(node ~= nil, "[UI] LayerStack.insertLayerData layer data's creator must return a cc.Node!")
			table.insert(children, layerIndex, node)
			node:retain()
			self:addChild(node)
		end
	end

	local function oncleanup()
		for k, v in pairs(children) do
			if v then
				if v:getParent() then
					v:removeFromParent()
				end
				v:release()
			end
		end
		children = {}
	end
	if not params.delayCleanup then
		ls:onNodeEvent("cleanup", oncleanup)
	else
		ls:onNodeEvent("cleanup", function()
			Scheduler.scheduleNextFrame(oncleanup)
		end)
	end

	return ls
end
