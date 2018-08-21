module("THSTG.UI", package.seeall)

--滑动条默认背景皮肤
SLIDER_BG_SKIN = {
	src = "",--ResManager.getUIRes(UIType.SLIDER, "slider_bg1"),
	scale9Rect = {left = 10, right = 10, top = 5, bottom = 5}
}
--滑动条默认进度皮肤
SLIDER_PROGRESS_SKIN = {
	src = "",--ResManager.getUIRes(UIType.SLIDER, "slider_sel1"),
	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
}
--滑动条默认滑动点皮肤
SLIDER_THUMB_SKIN = {
	src = "",--ResManager.getUIRes(UIType.SLIDER, "slider_btn1"),
}

--[[
Slider组件
@param	x					[number]    x坐标
@param	y					[number]    y坐标
@param	width 				[number]	宽度
@param	height				[number]	高度
@param	anchorPoint			[cc.p]		锚点(如UI.POINT_LEFT_BOTTOM)
@param	percent				[number]	进度，取值[0-100]，默认0
@param	enabled				[boolean]	是否可用，默认true
@param	onChange			[function]	进度变更时的回调函数，如：local function onChange(sender, percent) print(sender, percent) end
@param	style            	[table]     
		{
			bgSkin = THSTG.UI.SLIDER_BG_SKIN, 背景皮肤
			progressSkin = THSTG.UI.SLIDER_PROGRESS_SKIN, 进度皮肤
			thumbSkin = THSTG.UI.SLIDER_THUMB_SKIN				移动块皮肤
}
]]
function newSlider(params)
	if params then
		assert(type(params) == "table", "[UI] newSlider() invalid params")
	else
		params = {}
	end

	local finalParams = {
		x = 0, 
		y = 0,
		width = 200, 
		height = 100,
		anchorPoint = clone(THSTG.UI.POINT_CENTER),
		percent = 0,
		enabled = true,
		style = {
			bgSkin = clone(THSTG.UI.SLIDER_BG_SKIN),
			progressSkin = clone(THSTG.UI.SLIDER_PROGRESS_SKIN),
			thumbSkin = clone(THSTG.UI.SLIDER_THUMB_SKIN),
		}
	}
	THSTG.TableUtil.mergeA2B(params, finalParams)

	local slider = ccui.Slider:create(finalParams.style.bgSkin.src, finalParams.style.thumbSkin.src)
	slider:loadProgressBarTexture(finalParams.style.progressSkin.src)
	slider:ignoreContentAdaptWithSize(false)
	slider:setZoomScale(0.2)
	slider:setPosition(finalParams.x, finalParams.y)
	slider:setContentSize(cc.size(finalParams.width, finalParams.height))
	slider:setAnchorPoint(finalParams.anchorPoint)

	local capInsets = THSTG.UI.skin2CapInsets(finalParams.style.progressSkin)
	if capInsets then
		slider:setScale9Enabled(true)
		slider:setCapInsets(capInsets)
	end

	--用于去除无谓的调用
	local _prevPercent = finalParams.percent
	local function onChange(sender)
		if _prevPercent == sender:getPercent() then 
			return 
		end
		_prevPercent = sender:getPercent()

		if type(params.onChange) == "function" then
			params.onChange(sender, sender:getPercent())
		end
	end
	slider:addEventListener(onChange)

	--重写setPercent接口
	local __setPercent = slider.setPercent
	function slider:setPercent(value, change)
		__setPercent(self, value)
		if change == nil or change == true then
			onChange(self)
		elseif change == false then
			
		end
	end

	--重写setEnabled接口
	local __setEnabled = slider.setEnabled
	function slider:setEnabled(value)
		__setEnabled(self, value)
		self:setBright(value)
	end


	slider:setPercent(finalParams.percent)
	slider:setEnabled(finalParams.enabled)

	return slider
end
