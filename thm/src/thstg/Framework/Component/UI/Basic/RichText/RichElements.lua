module("UI", package.seeall)

-----------------------------
-- 创建一个使用ttf字体文件的文本
-- @param	text			[string]	显示的文字
-- @param	x				[number]	x坐标
-- @param	y				[number]	y坐标
-- @param	width			[number]	宽度
-- @param	height			[number]	高度
-- @param	anchorPoint		[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
-- @param	style			[table]		文字格式(参考Style文件中的newTextStyle()方法)
function newRichElementButton(params)
	local btn = newButton(params)
	local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, btn)

	return element
end

function newRichElementLabel(params)
	local label = newLabel(params)
	local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, label)

	return element
end

function newRichElementImage(params)
	local img = newImage(params)
	local element = ccui.RichElementCustomNode:create(0, display.COLOR_WHITE, 255, img)

	return element
end