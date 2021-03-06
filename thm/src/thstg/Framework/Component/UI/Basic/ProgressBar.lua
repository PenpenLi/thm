module("UI", package.seeall)

PROGRESS_BAR_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = clone(UI.POINT_CENTER),
	value = 100,
	maxValue = 100,
	showLabel = false,
	showBlood = false,
	bloodStyle = {style = false, x = 0, size = 20},
	progressPadding = cc.p(0, 0),
	progressOffset = cc.p(0, 0),
	addProgressPadding = cc.p(0, 0),
	addProgressOffset = cc.p(0, 0),
	style = {
		--文本默认样式
		label = UI.newTextStyle({size = UI.FONT_SIZE_SMALL}),
		labelAnchorPoint = UI.POINT_CENTER,
		--背景皮肤
		bgSkin = {
			src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.PROGRESS_BAR, "prog_bar_bg2"),
			scale9Rect = {left = 5, right = 5, top = 5, bottom = 5}
		},
		--进度条皮肤
		progressSkin = {
			src = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.PROGRESS_BAR, "prog_bar_item2"),
			scale9Rect = {left = 5, right = 5, top = 5, bottom = 5}
		}
	}
}

PROGRESS_RADIAL_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = clone(UI.POINT_CENTER),
	value = 100,
	maxValue = 100,
	minValue = 0,
	midPoint = cc.p(0.5,0.5),	--(0.5,0.5)
	offset = 0,
	isReverse = false,
	debug = false,
	style = {
		--背景皮肤
		bgSkin = {
			src = "",
			-- src = ResManager.getResSub(ResType.UIBASE,UIBaseType.PROGRESS_BAR, "prog_radial_bg"),
			
		},
		--进度条皮肤
		progressSkin = {
			src = "",
			-- src = ResManager.getResSub(ResType.UIBASE,UIBaseType.PROGRESS_BAR, "prog_radial_hp"),
			
		}
	}
}

--[[
--ProgressBar组件
@params  x					[number]    进度条整体X坐标
@params  y					[number]    进度条整体Y坐标
@params  width 				[number]	进度条需要拉伸宽度
@params  height				[number]	进度条需要拉伸高度
@params  anchorPoint		[cc.p]		锚点，默认UI.PONIT_CENTER
@params  progressPadding	[cc.p]		进度条比背景小的尺寸，默认(0, 0)
@params  progressOffset		[cc.p]		进度条相对背景的偏移值，默认(0, 0)
@params  showLabel			[boolean]	是否显示进度条文本，默认false
@params  isCanOverMaxValue	[boolean]	显示文本的时候是否能够超过最大值
@params  labelFormater		[function]	进度条文本显示格式化函数，格式如：
							function formater(value, maxValue) 
								return string.format("%d%", math.ceil(value / maxValue * 100))
							end
@params  style				[table]     各组件部分样式
    {
    	label = UI.newTextStyle(), 
    	bgSkin = {
    		src = "aa.png", 
    		scale9Rect = {left = 1, right = 1, top = 1, bottom = 1}
}, --可以指定常用Scale9数据或者false，为false时表示无背景
    	progressSkin = {
    		src = "bb.png", 
    		scale9Rect = {left = 1, right = 1, top = 1, bottom = 1}
}
    	addSkin = {
    		src = "bb.png", 
    		scale9Rect = {left = 1, right = 1, top = 1, bottom = 1}
}
		--默认状态下scale9Rect的四个值都是0，left：左边距，right：右边距，top：上边距，bottom：下边距
}
注意:进度条进度支持传入两种格式化数字，如同时传入两种格式化数字
程序将自动使用progressValue显示当前进度
]]--
function newProgressBar(params)
	
	assert(type(params) == "table", "[UI] newProgressBar() invalid params")
	local paramsStyle = params.style or {}
	local isCanOverMaxValue= params.isCanOverMaxValue
	local finalParams = clone(PROGRESS_BAR_DEFAULT_PARAMS)
	if params.style then
		if params.style.bgSkin == false then
			finalParams.style.bgSkin = nil
		end
		if type(params.style.bgSkin) == "table" or type(params.style.progressSkin) == "table" then
			finalParams.progressPadding.x = 0
			finalParams.progressPadding.y = 0
		end
	end
	TableUtil.mergeA2B(params, finalParams)

	local _value, _maxValue, _addValue = 100, 100, 0
	local _bloodNum = 0

	local node = UI.newWidget()
	node:setAnchorPoint(finalParams.anchorPoint)
	node:setPosition(finalParams.x, finalParams.y)

	---------------------------
	--背景块（可为空）
	local bg = nil

	local bgCapInsets, bgOrgSize = UI.skin2CapInsets(finalParams.style.bgSkin)
	if bgCapInsets then
		bg = ccui.Scale9Sprite:create(finalParams.style.bgSkin.src, cc.rect(0, 0, bgOrgSize.width, bgOrgSize.height), bgCapInsets)
		if finalParams.width <= 0 then
			finalParams.width = bgOrgSize.width
		end
		if finalParams.height <= 0 then
			finalParams.height = bgOrgSize.height
		end
	else
		if finalParams.style.bgSkin and finalParams.style.bgSkin.src then
			bg = cc.Sprite:create(finalParams.style.bgSkin.src)
			if finalParams.width <= 0 then
				finalParams.width = bg:getContentSize().width
			end
			if finalParams.height <= 0 then
				finalParams.height = bg:getContentSize().height
			end
		end
	end

	if bg then
		node:addChild(bg)
		bg:setAnchorPoint(UI.POINT_LEFT_BOTTOM)
		bg:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	---------------------------
	local addbar = nil
	if paramsStyle.addSkin then
		addbar = ccui.LoadingBar:create(paramsStyle.addSkin.src, _value / _maxValue * 100)
		addbar:setAnchorPoint(UI.POINT_LEFT_BOTTOM)
		addbar:setPercent(0)
		node:addChild(addbar)
	end

	local bar = ccui.LoadingBar:create(finalParams.style.progressSkin.src, _value / _maxValue * 100)
	bar:setAnchorPoint(UI.POINT_LEFT_BOTTOM)
	node:addChild(bar)


	local function initBar(info)
		info = info or {}
		local barCapInsets, barOrgSize = UI.skin2CapInsets(info.skin)
		if barCapInsets then
			info.bar:setScale9Enabled(true)
			info.bar:setCapInsets(barCapInsets)

			if not bg then
				if finalParams.width <= 0 then
					finalParams.width = barOrgSize.width
				end
				if finalParams.height <= 0 then
					finalParams.height = barOrgSize.height
				end
			end
		else
			if not bg then
				if finalParams.width <= 0 then
					finalParams.width = info.bar:getContentSize().width
				end
				if finalParams.height <= 0 then
					finalParams.height = info.bar:getContentSize().height
				end
			end
		end
		info.bar:setContentSize(cc.size(finalParams.width-info.padding.x * 2, finalParams.height-info.padding.y * 2))
		info.bar:setPosition(info.padding.x + info.offset.x, info.padding.y + info.offset.y)
	end
	initBar({
		bar = bar,
		padding = finalParams.progressPadding,
		offset = finalParams.progressOffset,
		skin = finalParams.style.progressSkin,
	})
	if addbar then
		initBar({
			bar = addbar,
			padding = finalParams.addProgressPadding,
			offset = finalParams.addProgressOffset,
			skin = paramsStyle.addSkin
		})
	end
	-------------------------------
	--进度文本
	local label = nil
	if finalParams.showLabel then
		label = UI.newLabel({
			text = tostring(_value / _maxValue * 100).."%",
			x = params.labelOffsetX or finalParams.width / 2 + (params.labelPyx or 0),
			y = params.labelOffsetY or finalParams.height / 2 + (params.labelPyy or 0),
			anchorPoint = finalParams.style.labelAnchorPoint or UI.POINT_CENTER,
			style = finalParams.style.label,
		})
		node:addChild(label)
	end

	-- 血管条数
	local bloodLabel
	if finalParams.showBlood then
		local fontSize = 18
		local bloodX = params.labelOffsetX or finalParams.width + (params.labelPyx or 0) - finalParams.width / 15
		if finalParams.bloodStyle.style then
			fontSize = finalParams.bloodStyle.size
			bloodX = finalParams.bloodStyle.x
		end
		bloodLabel = UI.newLabel({
			text = "X1",
			x = bloodX,
			y = params.labelOffsetY or finalParams.height / 2 + (params.labelPyy or 0),
			anchorPoint = UI.POINT_RIGHT_CENTER,
			style = {

				color = UI.htmlColor2C3b("#ffffff"),
				size = fontSize,
				outlineColor = UI.htmlColor2C3b("#535551"),
				outline = 1,
			},
		})
		node:addChild(bloodLabel, 10)
	end

	local function updateLabel()
		if label then
			if params.disabledLabel then
				-- 不更新label
			else
				if type(params.labelFormater) == "function" then
					local text = params.labelFormater(_value, _maxValue)
					assert(text ~= nil, "[ProgressBar] param.labelFormater must return a string!")
					label:setText(text)
				else
					label:setText(tostring(math.ceil(_maxValue == 0 and 100 or _value / _maxValue * 100)).."%")
				end
			end
		end
		if bloodLabel then
			local str = string.format("X%d", _bloodNum)
			bloodLabel:setText(str)
		end
	end
	-------------------------------

	-- false-切割，true-缩放
	function node:setScale9Enabled(flag)
		bar:setScale9Enabled(flag)
	end

	-- 设置自定义文字
	function node:setText(str)
		if(not label)then
			label = UI.newLabel({
				x = params.labelOffsetX or finalParams.width / 2 + (params.labelPyx or 0),
				y = params.labelOffsetY or finalParams.height / 2 + (params.labelPyy or 0),
				anchorPoint = finalParams.style.labelAnchorPoint or UI.POINT_CENTER,
				style = finalParams.style.label,
			})
			node:addChild(label)
		end
		label:setText(str)
	end

	function node:getLabel()
		return label
	end


	--当前值
	function node:getValue() return _value end
	local timer = false
	function node:setValue(value, needAction, msgNum)
		if value > _maxValue then
			value = _maxValue
		elseif value < 0 then
			value = 0
		end
		if _value ~= value then
			local preValue = _value
			
			_value = value
			local newPercent = _maxValue == 0 and 100 or _value / _maxValue * 100
			
			if timer then
				Scheduler.unschedule(timer)
				timer = false
			end 
			if needAction then
				local size = bar:getContentSize() 
				if _value > preValue then
					
					local lb =  UI.newBMFontLabel({
						text =  string.format("+%s",msgNum or (_value-preValue)),
						anchorPoint = ccp(1,0),
						x = size.width,
						y = size.height,

						style = {
							font = "",--ResManager.getResSub(ResType.FONT, FontType.FNT, "get_exp"),
							additionalKerning = -6,
						}
					})
					
					bar:addChild(lb)
					
					transition.moveTo(lb, {
						time = 0.45,
						x = size.width,
						y = size.height+ 70,
						onComplete = function ( target )
							target:removeFromParent()
						end
					})
				end
				if self.needSmooth then
					local needShowMax = 0 
					if _value<preValue then
						needShowMax = 1
					end
					timer = Scheduler.schedule(function ( t )
						if needShowMax > 0 then
								bar:setPercent(100)
								needShowMax = needShowMax - 1
							return 
						end 
						local add = t*250
						local pr = add/size.width*100
						local oldPercent = bar:getPercent()
						if oldPercent == 100 then
							oldPercent = 0
						end 
						local cur = oldPercent+pr
						if cur >= newPercent then
							Scheduler.unschedule(timer)
							timer = false
							bar:setPercent(newPercent)
						else
							bar:setPercent(cur)
						end 
					end,0)
				else
					bar:setPercent(newPercent)
				end 
			else
				bar:setPercent(newPercent)
			end 
			updateLabel()
		end
	end
	node:onNodeEvent("exit",function ( ... )
		if timer then
			Scheduler.unschedule(timer)
		end 
	end)
	--最大值
	function node:getMaxValue() return _maxValue end
	function node:setMaxValue(value)
		if value < 0 then value = 0 end

		if _maxValue ~= value then
			_maxValue = value

			if _maxValue < _value then
				_value = value
			end

			bar:setPercent(_maxValue == 0 and 100 or _value / _maxValue * 100)
			updateLabel()
		end
	end

	--进度百分比，取值[0-1]
	function node:getPercent() return _value / _maxValue end
	function node:setPercent(value)
		if value < 0 then
			value = 0
		elseif value > 1 then
			value = 1
		end
		self:setValue(_maxValue * value)
	end

	-- 血管数
	function node:getBloodNum() return _bloodNum end
	function node:setBloodNum(value)
		value = value or 1
		if value < 0 then
			value = 0
		end
		_bloodNum = value
	end

	--同时更新当前值和最大值
	function node:refresh(value, maxValue)
		local changed = false
		if _maxValue ~= maxValue then
			_maxValue = maxValue
			changed = true
		end

		if _value ~= value then
			_value = value
			changed = true
		end

		if _value > _maxValue then
			if(not isCanOverMaxValue)then
				_value = _maxValue
				changed = true
			end
		end

		if changed then
			bar:setPercent(_maxValue == 0 and 100 or _value / _maxValue * 100)
			updateLabel()
		end
	end

	local flashing = false
	function node:setValueByInfo(value)
		value = value or {}

		-- 血管
		if type(value.bloodNum) == "number" then
			node:setBloodNum(value.bloodNum)
		end
		if type(value.max) == "number" then
			node:setMaxValue(value.max)
		end
		if type(value.value) == "number" then
			node:setValue(value.value)
		end
		if type(value.add) == "number" and addbar then
			_addValue = value.add
			addbar:setPercent(math.min((_value + _addValue), _maxValue) / _maxValue * 100)
		end

	
		if addbar then
			if _addValue > 0 and _addValue + _value >= _maxValue then
				if not flashing then
					flashing = true
					addbar:stopAllActions()
					addbar:runAction(cc.RepeatForever:create(cc.Sequence:create({cc.FadeOut:create(1.5), cc.FadeIn:create(1.5), cc.DelayTime:create(0.5)})))
				end
			elseif _addValue > 0 and value.action then
				if not flashing then
					flashing = true
					addbar:stopAllActions()
					addbar:runAction(cc.RepeatForever:create(cc.Sequence:create({cc.FadeOut:create(1.5), cc.FadeIn:create(1.5), cc.DelayTime:create(0.5)})))
				end

			elseif flashing then
				flashing = false
				addbar:stopAllActions()
				addbar:setOpacity(255)
			end
		end

	end
	function node:setDirection(toRight)
		if toRight then
			bar:setDirection(1)
		else
			bar:setDirection(2)
		end

	end

	function node:updateStyle(style)
		style = style or {}
		local barCapInsets, barOrgSize = UI.skin2CapInsets(style.progressSkin)
		if style.progressSkin and style.progressSkin.src then
			bar:loadTexture(style.progressSkin.src)
		end
		barCapInsets, barOrgSize = UI.skin2CapInsets(style.bgSkin)
		if style.bgSkin and style.bgSkin.src then
			if bg then
				bg:loadTexture(style.bgSkin.src)
			end
		end
	end

	function node:getBgNode()
		return bg
	end

	function node:getFrontNode()
		return bar
	end

	node:setContentSize(finalParams.width, finalParams.height)
	node:setMaxValue(finalParams.maxValue)
	node:setValue(finalParams.value)
	if params.toRight then
		node:setDirection(true)
	end
	if type(params.isScale9) == "boolean" then
		bar:setScale9Enabled(params.isScale9)
	end
	updateLabel()

	return node
end

--多个血条
function newMultiProgressBar(params)
	params = params or {}

	local data = params.data or {}
	local node = UI.newWidget({
		x = params.x,
		y = params.y,
		anchorPoint = params.anchorPoint,
	})
	local bg1, bg2
	local bar1, bar2

	if type(data.bg1) == "table" then
		bg1 = UI.newScale9Sprite(data.bg1)
		node:addChild(bg1)
	end

	local maxValue, curValue, preBgParams = 100
	data.bar = data.bar or {}


	local barNum = #data.bar
	if barNum >= 1 then
		local info = data.bar[1]
		local bar1Params, bar2Params = info.bar1, info.bar2
		bar2 = UI.newProgressBar({
			anchorPoint = UI.POINT_LEFT_BOTTOM,
			style = {
				bgSkin = false,
				progressSkin = bar2Params.progressSkin,
			},
		})
		node:addChild(bar2, 2)

		bar1 = UI.newProgressBar({
			anchorPoint = UI.POINT_LEFT_BOTTOM,
			showLabel = params.showLabel,
			showBlood = params.showBlood,
			bloodStyle = params.bloodStyle,
			style = {
				bgSkin = false,
				progressSkin = bar1Params.progressSkin,
				label = bar1Params.label,
			},
			labelFormater = function (value, max)
				return tostring(math.ceil((curValue or 0) / maxValue * 100)).."%"
			end
		})
		node:addChild(bar1, 2)
		node:setContentSize(bar1:getContentSize())
	end

	local function getIndex(value, max)
		local rate = value / max
		if max <= 0  then
			rate = 1
		end
		local refRate = 0
		for i = barNum, 1, -1 do
			local itemR = (data.bar[i].rate or (1 / barNum))
			if rate <= refRate + itemR then
				return i, rate - refRate, itemR
			end
			refRate = refRate + itemR
		end
		return 1, (data.bar[1].rate or (1 / barNum)), (data.bar[1].rate or (1 / barNum))
	end

	function node:setValueByInfo(info)
		if barNum >= 1 then
			info = info or {}
			local needAction = info.action
			local value, max = info.value or 0, info.max or maxValue
			value = math.max(0, value)
			max = math.max(0, max)
			if max == 0 then
				max, value = 100, 0
			end
			value = math.min(max, value)
			local isDes = curValue and curValue > value
			maxValue, curValue = max, value
			local index, valueRate, maxRate = getIndex(value, max)
			local barInfo, nextBgInfo = data.bar[index], data.bar[index + 1]
			local bar1Params, bar2Params, bgParam = barInfo.bar1, barInfo.bar2

			if nextBgInfo then
				bgParam = nextBgInfo.bar1
			end
			
			if bar1 then
				if bar1.curParam ~= bar1Params then
					bar1.curParam = bar1Params
					bar1:updateStyle(bar1Params)
				end
				bar1:setValueByInfo({
					value = valueRate * max,
					max = maxRate * max,
					bloodNum = barNum-index + 1,
				})
			end

			if bar2 then
				if bar2.curParam ~= bar2Params then
					bar2.curParam = bar2Params
					bar2:updateStyle(bar2Params)
				end
				bar2:stopAllActions()
				if needAction ~= false and isDes then
					local curPercent = bar2:getPercent()
					bar2:runAction(cc.EaseIn:create(cc.ActionFloat:create(0.3, curPercent * 100, valueRate / maxRate * 100, function (value)
						bar2:setPercent(value / 100)
					end), 2))
				else
					bar2:setValueByInfo({
						value = valueRate * max,
						max = maxRate * max,
						bloodNum = barNum-index + 1,
					})
				end
			end

			if bgParam then
				if bgParam ~= preBgParams then
					preBgParams = bgParam
					if bg2 and not tolua.isnull(bg2) then
						bg2:removeFromParent(true)
					end
					bg2 = UI.newScale9Sprite({
						style = bgParam.progressSkin,
						anchorPoint = UI.POINT_LEFT_BOTTOM,
					})
					node:addChild(bg2)
				end
			else
				if bg2 and not tolua.isnull(bg2) then
					preBgParams = false
					bg2:removeFromParent(true)
				end
				bg2 = false
			end
		end
	end

	function node:setValue(value)
		node:setValueByInfo({
			value = value,
		})
	end
	function node:getValue()
		return curValue
	end


	node:setValueByInfo({
		value = params.value or 100,
		max = params.max or 100,
		bloodNum = 1,
	})

	return node
end


--环形进度条
--[[
@params  x					[number]    进度条整体X坐标
@params  y					[number]    进度条整体Y坐标
@params  width 				[number]	进度条需要拉伸宽度
@params  height				[number]	进度条需要拉伸高度
@params  anchorPoint		[cc.p]		锚点，默认UI.PONIT_CENTER
@params  value 				[number] 	值
@params  maxValue 			[number]	最大值
@params  minValue 			[number]	最小值
@params  midPoint 			[cc.p] 		圆心位置
@params  offset				[number]	起始偏移角度值
@params  isReverse  		[bool] 		是否逆时针
@params  debug  			[bool] 		方便对位置用
@params  style				[table]     各组件部分样式
{
	bgSkin = {
		src = "aa.png", 
	}
	progressSkin = {
		src = "bb.png", 
	}
}
]]--
function newRadialProgressBar(params)

	assert(type(params) == "table", "[UI] newRadialProgressBar() invalid params")
	local paramsStyle = params.style or {}
	local finalParams = clone(PROGRESS_RADIAL_DEFAULT_PARAMS)
	
	TableUtil.mergeA2B(params, finalParams)

	local node = UI.newWidget()
	node:setAnchorPoint(finalParams.anchorPoint)
	node:setPosition(finalParams.x, finalParams.y)

	if finalParams.style.bgSkin then
		local bg_sprite = cc.Sprite:create(finalParams.style.bgSkin.src)
		-- bg_sprite:setOpacity(255)
		node:addChild(bg_sprite,-10)
	end
	--关于offset原理:旋转纹理,旋转prog
	local tempHpSprite = cc.Sprite:create()
	local size = UI.getSkinSize(finalParams.style.progressSkin.src)
	local render = cc.RenderTexture:create(size.width,size.height)
	render:beginWithClear(0,0,0,0)

	tempHpSprite:setTexture(finalParams.style.progressSkin.src)
	tempHpSprite:setAnchorPoint(cc.p(0.5,0.5))
	tempHpSprite:setPosition(size.width/2,size.height/2)
	tempHpSprite:setRotation(finalParams.offset)
	tempHpSprite:setFlippedY(true)--渲染到renderTeX的纹理都是上下颠倒的
	--注:这里在测试面板看不到,是因为渲染循序可能有问题,就是说还没渲染到renderTeX上就已经创建hp_sprite了,所以导致看不到效果,需要先按T(重新加载),在打开测试面板
	--:实际是正常的,为了保险还是先保证renderTeX渲染完成在创建hp_sprite,就是在下一帧时创建hp_sprite和组件
	tempHpSprite:visit()

	render:endToLua()

	local hp_sprite = cc.Sprite:createWithTexture(render:getSprite():getTexture())
    local radialProgressBar = cc.ProgressTimer:create(hp_sprite)
	radialProgressBar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
	node:addChild(radialProgressBar)

	radialProgressBar:setReverseProgress(finalParams.isReverse)
	radialProgressBar:setMidpoint(finalParams.midPoint)
	radialProgressBar:setRotation(finalParams.offset)

	local debugProg = nil
	if finalParams.debug then
		local function createColorSprite(size,color)
			local render = cc.RenderTexture:create(size.width,size.height)
			render:beginWithClear(color.r, color.g, color.b, color.a)
			render:visit()
			render:endToLua()
			return cc.Sprite:createWithTexture(render:getSprite():getTexture())
		end
		local debugHp = createColorSprite(radialProgressBar:getContentSize(),{r=1,g=0,b=0,a=0.5})
		debugProg = cc.ProgressTimer:create(debugHp)
		debugProg:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
		debugProg:setReverseProgress(finalParams.isReverse)
		debugProg:setMidpoint(finalParams.midPoint)
		debugProg:setRotation(finalParams.offset)
		node:addChild(debugProg)
	end
	--
	function node:setPercentage(val)
		radialProgressBar:setPercentage(val)
		if debugProg then
			debugProg:setPercentage(val)
		end
	end
	function node:getPercentage()
		return radialProgressBar:getPercentage()
	end

	function node:setAngle(val)
		self:setPercentage(5*val/18)
	end

	function node:getAngle()
		return 18*self:getPercentage()/5
	end

	local function getFixValue(val)
		local allowValue = 	finalParams.maxValue - finalParams.minValue
		local finalValue = finalParams.minValue + allowValue * val * 0.01
		finalValue = math.max(finalValue,finalParams.minValue)
		finalValue = math.min(finalValue,finalParams.maxValue)
		return finalValue
	end

	local function getOriValue(finalValue)
		local allowValue = 	finalParams.maxValue - finalParams.minValue
		local val = (finalValue - finalParams.minValue) / (allowValue * 0.01)

		return val
	end

	function node:setValue(val)
		local finalValue = getFixValue(val)
		self:setPercentage(finalValue)

		
	end
	function node:getValue()
		local finalValue = self:getPercentage()
		local val = getOriValue(finalValue)

		return val
	end

	function node:refresh(value, maxValue)
		self:setValue(100 * value/maxValue)
	end

	function node:progressFromTo(time,from,to)
		local finalFromValue = getFixValue(from)
		local finalToValue = getFixValue(to)
		radialProgressBar:runAction(cc.ProgressFromTo:create(time,finalFromValue,finalToValue))
	end
	
	node:setContentSize(finalParams.width, finalParams.height)
	node:setValue(finalParams.value)

	return node
end