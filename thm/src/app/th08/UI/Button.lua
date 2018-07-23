module("UI", package.seeall)

--默认皮肤
BUTTON_DEFAULT_PARAMS = {
	text = "",
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = THSTG.UI.POINT_CENTER,
	zoomScale = 0.1,
	enabled = true,
	style = {
		normal = {
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
		selected = {
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
		disabled = {
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
	}
}
--[[
创建Button

@notice button 的背景图片大小需一致否则，拉伸区域会与预期输入不符。因为button默认拉伸区域取第一张图的。效率问题暂时不改button实现，如需要可以独立修改各状态背景

params中可用参数：
@param	text		[string]	按钮上的文字
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param	width		[number]	宽度
@param	height		[number]	高度
@param	anchorPoint	[cc.p]		锚点(如UI.POINT_CENTER)
@param	tag			[number]	tag标识
@param	enabled		[boolean]	是否可用, 为false时显示为disabled状态
@param	zoomScale	[number]	点击放大倍数, 最终scale = scale + zoomScale, 默认值0.1
@param  isTouchAction [bool]    是否点击动画
@param	onTouch		[function]	点击回调函数(按钮上执行的各种事件)
@param	onClick		[function]	点击回调函数(在按钮上按下并且松开)
@param	style		[table]		样式，结构如：
								{
									normal = {
										label = {font = "MicrosoftYaHei", size=19, color="#FFFFFF"}, 
										skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal"), isRevers = true}, 
}, 
									selected = {
										label = {color = "#00FF00"}, 
										skin = {scale9Rect = {left = 25, right = 25, top = 10, bottom = 10}}
}, 
									disabled = {
										label = {color = "#999999"}, 
										--默认状态下scale9Rect的四个值都是0，left：左边距，right：右边距，top：上边距，bottom：下边距
										skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}
]]
function newButton(params)
    params = params or {}

	-- 不用写这么多 style = {normal = {skin = {} } }
	if params.src then
		params.style = {
			normal = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			},
			selected = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			},
			disabled = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			}
		}
	end

	local finalParams = clone(BUTTON_DEFAULT_PARAMS)
	THSTG.TableUtil.mergeA2B(params, finalParams)

	if params.style then
		local paramsStyleNormal = params.style.normal
		if paramsStyleNormal then
	
			if paramsStyleNormal.skin then
				if not paramsStyleNormal.skin.scale9Rect then
					finalParams.style.normal.skin.scale9Rect = false --{left=0, right=0, top=0, bottom=0}
				end

				--如果有传入普通状态下的皮肤样式而没有传选中和不可用状态皮肤，则选中和不可用状态也用普通状态皮肤
				if not params.style.selected or not params.style.selected.skin then
					finalParams.style.selected.skin = clone(finalParams.style.normal.skin)
				end

				-- if not params.style.disabled or not params.style.disabled.skin then
				-- finalParams.style.disabled.skin = clone(finalParams.style.normal.skin)
				-- end
			end
		end
	end


	local styleNormal = finalParams.style.normal
	local styleSelected = finalParams.style.selected
    local styleDisabled = finalParams.style.disabled
    
    local btn = ccui.Button:create(styleNormal.skin.src, styleSelected.skin.src, styleDisabled.skin.src)
	btn:ignoreContentAdaptWithSize(false)

	--------------------------------

	--锚点设置
	btn:setAnchorPoint(finalParams.anchorPoint)
	--坐标设置
	btn:setPosition(finalParams.x, finalParams.y)
	--皮肤设置
	local normalCapInsets = THSTG.UI.skin2CapInsets(styleNormal.skin)
	if normalCapInsets then
		btn:setCapInsets(normalCapInsets)
		btn:setScale9Enabled(true)
	end
	local pressedCapInsets = THSTG.UI.skin2CapInsets(styleSelected.skin)
	if pressedCapInsets then
		btn:setCapInsetsPressedRenderer(pressedCapInsets)
	end
	local disabledCapInsets = THSTG.UI.skin2CapInsets(styleDisabled.skin)
	if disabledCapInsets then
		btn:setCapInsetsDisabledRenderer(disabledCapInsets)
	end

	--宽度设置
	if finalParams.width > 0 or finalParams.height > 0 then
		local texSize = btn:getVirtualRendererSize()
		if finalParams.width <= 0 then
			finalParams.width = texSize.width
		end
		if finalParams.height <= 0 then
			finalParams.height = texSize.height
		end
		btn:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	--文字设置
	if finalParams.text ~= "" then
		btn:setTitleText(finalParams.text)
	end

	--缩放设置
	if type(finalParams.zoomScale) == "number" then
		btn:setZoomScale(finalParams.zoomScale)
	end

	--回调设置
	local function onTouch(sender, eventType)
		local event = {x = 0, y = 0}
        event.target = sender
        
        if eventType == ccui.TouchEventType.began then
            --获取起始坐标
            local beganPos = sender:getTouchBeganPosition()
			event.name = "began"
        elseif eventType == ccui.TouchEventType.moved then
            --获取移动坐标
            local curPos = sender:getTouchMovePosition()
			event.name = "moved"
		elseif eventType == ccui.TouchEventType.ended then	
			event.name = "ended"
			if type(params.onClick) == "function" then
				params.onClick(sender, "click")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			event.name = "cancelled"
        end
		if type(params.onTouch) == "function" then
			params.onTouch(event, sender)
		end
	end
	btn:addTouchEventListener(onTouch)

	--触摸动画设置
	btn:setTouchEnabled(true)
	if params.isTouchAction ~= nil then
		btn:setPressedActionEnabled(params.isTouchAction)
	else
		btn:setPressedActionEnabled(true)
	end

	-----------------------------------------------------
	-- 添加一个点击函数
	function btn:onClick(func)
		params.onClick = func
	end

	function btn:setString(value)
		btn:setText(value)
	end
	function btn:getString()
		return btn:getText()
	end

	return btn


end