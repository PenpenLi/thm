module("UI", package.seeall)

--[[
ScrollView可滚动裁剪容器
@param  x						[Number]	x坐标
@param  y						[Number]	y坐标
@param  width					[Number]	滚动可见区域宽
@param  height					[Number]	滚动可见区域高									
@param	anchorPoint				[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
@param  direction				[Number]	可滚动方向，取值[ccui.ScrollViewDir]，默认ccui.ScrollViewDir.both 
@param	bounceEnabled			[boolean]	到达边缘后是否仍然可以拖动，默认为true
@param	propagateTouchEvents	[boolean]	是否传播点击事件，默认为true，一般该对象被添加到另一个ScrollView中时需设置为false
@param	style					[table]		背景，false:无(默认)，string:html颜色("#FFFFFF")，table:{src="资源路径", scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}}
		{
			bgColor = false, [boolean, cc.c3b]	背景颜色，为cc.c3b格式时显示为对应颜色，否则不显示，默认无
			bgSkin = {src = false, scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}}	[table]		背景皮肤，默认无
}
example:                                                
local sv1 = UI.newScrollView({
	x = display.cx, 
	y = 200, 
	width = 200, 
	height = 200, 
	innerWidth = 300, 
	innerHeight = 300, 
	bounceEnabled = false, 
	anchorPoint = UI.POINT_CENTER, 
	style = {
		bgColor = UI.COLOR_BLACK, 
		bgSkin = UI.TABBAR_DEFAULT_HT_NORMAL_SKIN
}
})
layer:addChild(sv1)

]]
function newScrollView(params)
	if params then
		assert(type(params) == "table", "[UI] newScrollView() invalid params")
	else
		params = {}
	end

	local finalParams = {
		x = 0, y = 0,
		width = 100, height = 100,
		innerWidth = 100, innerHeight = 100,
		anchorPoint = clone(POINT_LEFT_BOTTOM),
		bounceEnabled = true,
		propagateTouchEvents = true,
		direction = ccui.ScrollViewDir.both,
		isClipType = false,
		style = {
			bgColor = false,
			bgSkin = {src = false, scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}},
		}
	}
	TableUtil.mergeA2B(params, finalParams)

	local scrollView = ccui.ScrollView:create()
	scrollView:setPosition(finalParams.x, finalParams.y)
	scrollView:setContentSize(cc.size(finalParams.width, finalParams.height))
	scrollView:setInnerContainerSize(cc.size(finalParams.innerWidth, finalParams.innerHeight))
	scrollView:setDirection(finalParams.direction)
	scrollView:setBounceEnabled(finalParams.bounceEnabled)
	scrollView:setAnchorPoint(finalParams.anchorPoint)
	scrollView:setPropagateTouchEvents(finalParams.propagateTouchEvents)
	-- cocos2 3.81后默认带有scrollbar
	scrollView:setScrollBarEnabled(false)

	if type(finalParams.style.bgColor) == "table" then
		scrollView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		scrollView:setBackGroundColor(finalParams.style.bgColor)
	end

	if type(finalParams.style.bgSkin.src) == "string" then
		scrollView:setBackGroundImage(finalParams.style.bgSkin.src)
		local capInsets = UI.skin2CapInsets(finalParams.style.bgSkin)
		if capInsets then
			scrollView:setBackGroundImageScale9Enabled(true)
			scrollView:setBackGroundImageCapInsets(capInsets)
		end
	end

	if finalParams.isClipType then
		scrollView:setClippingType(ccui.ClippingType.SCISSOR)
	end

	return scrollView
end
