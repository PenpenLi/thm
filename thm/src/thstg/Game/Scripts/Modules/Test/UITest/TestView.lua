module(..., package.seeall)

local M = class("TestModule", View)

function M:onCreate()
    local win = UI.newWindow({
		showTitle = false,
		-- width = 960,
		-- height = 640,
		width = display.width,
		height = display.height,
		x = display.cx,
		y = display.cy,
		onBack = function ()
			Dispatcher.dispatchEvent(EventType.PUBLIC_CLOSE_MODULE, ModuleType.TEST)
			Dispatcher.dispatchEvent(EventType.PUBLIC_OPEN_MODULE, ModuleType.TEST)
		end,
		onClose = handler(self, self.__onClose),
	})

	local UITest1 = require "Game.Modules.Test.UITest1"
	local ls = UI.newLayerStack({
		layers = {
			{data = "基础组件1", creator = UITest1.create},
		}
	})
	win:addChild(ls, 1)

	local tabBar = UI.newTabBar({
		dataProvider = ls:toDataProvider(),
		x = win:getContentSize().width / 2 - 30,
		y = win:getContentSize().height - 25,
		selectedIndex = LastSelected or 1,
		itemHeight = 40,
		itemGap = 0,
		anchorPoint = UI.POINT_CENTER,
		style = {
			normal = {label = {outline = 1}}
		},
		onChange = function(sender, selectedIndex, prevSelectedIndex)
			ls:setSelectedIndex(selectedIndex)
			LastSelected = selectedIndex
		end
	})
	win:addChild(tabBar, 2)

	local childNodes = win:getChildren()
	for k, v in pairs(childNodes) do
		v:setVisible(true)
	end
end

return M
------------------------------------------------
	