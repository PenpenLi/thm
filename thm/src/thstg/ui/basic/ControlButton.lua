module("thstg.UI", package.seeall)

TOUCH_DOWN = "touch_down"
DRAG_INSIDE = "drag_inside"
DRAG_OUTSIDE = "drag_outside"
DRAG_ENTER = "drag_enter"
DRAG_EXIT = "drag_exit"
TOUCH_UP_INSIDE = "touch_up_inside"
TOUCH_UP_OUTSIDE = "touch_up_outside"
TOUCH_CANCEL = "touch_cancel"

local default = {
	actionTime = 0.05,
	face = function ()
		return newImage({
			width = 100,
			height = 30,
			style = {
				src = ResManager.getUIRes(UIType.BUTTON, "default_normal"),
				scale9Rect = {left = 10, right = 10, top = 10, bottom = 10},
			},
		})
	end,
}

--[[
@param  x, y				#number		坐标
@param  anchorPoint			#cc.p		描点
@param  scaleAnchorPoint	#cc.p		缩放描点
@param  width				#number		宽度，为nil时，默认显示节点的宽度
@param  height				#number		高度，为nil时， 默认显示节点的高度
@param  isTouchAction		#boolean	是否触发点击动画， 默认为真
@param  curFace				#any		初始化的显示节点，作为key传入createFace  
@param  curFaceNode			#cc.Node	初始化显示节点
@param  zoomScale			#number		缩放大小
@param  zoomTime			#number		缩放时间
@param  createFace			#function(key)	返回node值，控件的显示节点
@param  onControlTouch		#function(event) 扩展触摸事件：TOUCH_DOWN = "touch_down"
														DRAG_INSIDE = "drag_inside"
														DRAG_OUTSIDE = "drag_outside"
														DRAG_ENTER = "drag_enter"
														DRAG_EXIT = "drag_exit"
														TOUCH_UP_INSIDE = "touch_up_inside"
														TOUCH_UP_OUTSIDE = "touch_up_outside"
														TOUCH_CANCEL = "touch_cancel"

@param  onTouch				#function(event) 触摸事件, began, moved, ended, cancelled 事件
@param	onClick				#function	点击事件
@param  sound				#string		点击音效
@param  playSound			#boolean	是否播放点击音效
@param  redDotData			#table		红点提示相关数据
@param  redOffsetPos		#cc.p		红点位置偏移
]]

function newControlButton(params)
	if params then
		assert(type(params) == "table", "[UI] newControlButton() invalid params")
	else
		params = {}
	end
	local function tipLog(str)
	--print(168, "newControlButton: "..str)
	end

	local playSound = "ui_click"
	if params.playSound ~= nil then
		playSound = params.playSound
	end

	params = clone(params)
	if params.isTouchAction == nil then
		params.isTouchAction = true
	end

	local controlButton = ccui.Button:create()

	local privateData = {}
	privateData.face = {}
	privateData.curFace = nil
	privateData.createFace = nil
	privateData.isInside = false
	privateData.container = nil
	privateData.isHighlighted = false
	privateData.scheduleId = nil
	privateData.isLongClick = false
	privateData.curFaceKey = nil

	local controlButtonAddChild = controlButton.addChild
	function privateData.init()
		controlButton:setScale9Enabled(true)
		controlButton:onTouch(privateData.onTouch)
		controlButton:setPosition(cc.p(params.x or 0, params.y or 0))
		controlButton:setAnchorPoint(params.anchorPoint or POINT_LEFT_BOTTOM)
		privateData.container = ccui.Widget:create()
		privateData.container:setCascadeOpacityEnabled(true)
		privateData.container:setAnchorPoint(params.scaleAnchorPoint or POINT_CENTER)
		--修复此类按钮点击跳转到其它标签（仅从父节点移除未回收），再跳回来时按钮会播放缩小动画的bug
		privateData.container:onNodeEvent("exit", function()
			privateData.container:stopAllActions()
			privateData.container:setScale(1)
		end)
		controlButtonAddChild(controlButton, privateData.container)

		if params.zoomScale then
			controlButton:setZoomScale(params.zoomScale)
		end
		if type(params.createFace) == "function" then
			privateData.createFace = params.createFace
		else
			privateData.createFace = default.face
		end
		privateData.setFace(params.curFace or "init", params.curFaceNode)
	end
	-----------------------------------------------------------------------
	--主要函数
	--[[触摸事件]]
	function privateData.onTouch(event)
		-- print(77, "controllBtn onTouch")
		privateData.applyTouchAction()

		if type(params.onTouch) == "function" then
			params.onTouch(event)
		end

		local extendEvent = {name = "", target = event.target, position = nil}
		if event.name == "began" then
			privateData.isInside = true
			extendEvent.name = TOUCH_DOWN
			extendEvent.position = controlButton:getTouchBeganPosition()

			privateData.startLongClick(event)
		elseif event.name == "moved" then
			if not privateData.isLongClick and not controlButton:isHighlighted() then
				privateData.cancelLongClick()
			end

			extendEvent.position = controlButton:getTouchMovePosition()
			local isTouchMoveInside = controlButton:hitTest(extendEvent.position)
			if isTouchMoveInside and not privateData.isInside then
				extendEvent.name = DRAG_ENTER
			elseif isTouchMoveInside and privateData.isInside then
				extendEvent.name = DRAG_INSIDE
			elseif not isTouchMoveInside and privateData.isInside then
				extendEvent.name = DRAG_EXIT
			elseif not isTouchMoveInside and not privateData.isInside then
				extendEvent.name = DRAG_OUTSIDE
			end
			privateData.isInside = isTouchMoveInside
		elseif event.name == "ended" then
			extendEvent.position = controlButton:getTouchEndPosition()
			local isTouchMoveInside = controlButton:hitTest(extendEvent.position)
			if isTouchMoveInside then
				extendEvent.name = TOUCH_UP_INSIDE
			else
				extendEvent.name = TOUCH_UP_OUTSIDE
			end

			if type(playSound) == "string" then
				SoundManager.playSound(playSound)
			end

			if type(params.onClick) == "function" and not privateData.isLongClick then
				params.onClick(event.target)
				printStack(params.onClick)
			end
			privateData.cancelLongClick()
		else
			extendEvent.position = controlButton:getTouchEndPosition()
			extendEvent.name = TOUCH_CANCEL
		end

		if type(params.onControlTouch) == "function" then
			params.onControlTouch(extendEvent)
			printStack(params.onControlTouch)
		end


		--tipLog("event: "..tostring(extendEvent.name))
	end

	--[点击动画]
	function privateData.applyTouchAction()
		if params.isTouchAction then
			if privateData.isHighlighted ~= controlButton:isHighlighted() then
				privateData.isHighlighted = controlButton:isHighlighted()
				privateData.container:stopAllActions()
				if privateData.isHighlighted then
					local zoomScale = controlButton:getZoomScale()
					privateData.container:runAction(cc.ScaleTo:create(params.zoomTime or default.actionTime, 1 + zoomScale, 1 + zoomScale))
				else
					privateData.container:runAction(cc.ScaleTo:create(params.zoomTime or default.actionTime, 1, 1))
				end

			end
		end
	end

	--[[设置显示节点]]
	function privateData.setFace(key, customNode)
		if key then
			local node = nil
			if tolua.cast(customNode, "cc.Node") then
				node = customNode
				if privateData.face[key] then
					privateData.face[key]:removeFromParent()
					privateData.face[key] = nil
				end
			end
			node = node or privateData.face[key] or privateData.createFace(key)
			if not tolua.cast(node, "cc.Node") then
				tipLog("node is invalid created by key: "..tostring(key))
				return
			end
			if not privateData.face[key] then
				privateData.container:addChild(node, -100000)
				privateData.face[key] = node
			end

			if tolua.cast(privateData.curFace, "cc.Node") then
				privateData.curFace:setVisible(false)
			end
			privateData.curFace = node
			privateData.curFace:setVisible(true)

			privateData.updateContentSize()

			tipLog("cur face: "..tostring(key))
			privateData.curFaceKey = key
		else
			tipLog("key is nil")
		end

	end
	--[[更新大小]]
	function privateData.updateContentSize()
		-- print(77, "updateContentSize")
		local node = privateData.curFace
		local nodeSize = node:getContentSize()
		local ar = node:getAnchorPoint()
		local s = cc.size(params.width or nodeSize.width, params.height or nodeSize.height)
		node:setPosition((ar.x - 0.5) * nodeSize.width + s.width / 2, (ar.y - 0.5) * nodeSize.height + s.height / 2)

		privateData.setContentSize(controlButton, s)
		privateData.container:setContentSize(s)

		local ar = params.scaleAnchorPoint or POINT_CENTER
		privateData.container:setPosition(cc.p(ar.x * s.width, ar.y * s.height))
		--tipLog("updateContentSize: w: "..tostring(s.width).." h: "..tostring(s.height))

		setHitFactor(controlButton,params.hitLen)
	end

	--[[长按事件开始计时]]
	function privateData.startLongClick(event)
		privateData.isLongClick = false
		if privateData.oldPropageValue ~= nil then
			controlButton:setPropagateTouchEvents(privateData.oldPropageValue ~= false)
			--print(168, "triggerLongClick",privateData.oldPropageValue ~= false)
		end
		if type(params.onLongClick) == "function" then
			privateData.scheduleId = Scheduler.schedule(function ()
				privateData.scheduleId = nil
				controlButton:setHighlighted(false)
				privateData.applyTouchAction()
				privateData.oldPropageValue = controlButton:isPropagateTouchEvents()
				controlButton:setPropagateTouchEvents(false)
				privateData.triggerLongClick(controlButton)
				--print(168, "triggerLongClick")
			end, 0.3, 1)
		end

	end
	--[[长按事件取消]]
	function privateData.cancelLongClick(event)
		if privateData.scheduleId then
			Scheduler.unschedule(privateData.scheduleId)
			privateData.scheduleId = nil
			--print(168, "cancelLongClick")
		end
	end

	--[[长按事件触发]]
	function privateData.triggerLongClick(event)
		privateData.isLongClick = true
		if type(params.onLongClick) == "function" then
			params.onLongClick(controlButton)
		end
	end


	--------------------------------------------------------------------
	--外部接口
	--重载
	privateData.setContentSize = controlButton.setContentSize
	function controlButton:setContentSize(size)
		params.width = size.width
		params.height = size.height
		privateData.updateContentSize()
	end
	privateData.onNodeEvent = controlButton.onNodeEvent
	function controlButton:onNodeEvent(name, fun)
		if name == "exit" then
			privateData.onNodeEvent(self, name, function ()
				privateData.cancelLongClick()
				if type(fun) == "function" then
					fun()
				end
			end)
		else
			privateData.onNodeEvent(self, name, fun)
		end
	end

	function controlButton:onClick(func)
		params.onClick = func
	end

	--[[设置显示节点
	--key:   createFace的参入参数
	]]
	function controlButton:setFace(key, node)
		privateData.setFace(key, node)
	end

	--[[获取当前显示节点]]
	function controlButton:getFace(key)
		return privateData.face[key] or privateData.curFace
	end

	--[[获取容器节点]]
	function controlButton:getInnerContainer()
		return privateData.container
	end

	--[[更新大小]]
	function controlButton:updateContentSize()
		privateData.updateContentSize()
	end

	--重载相关函数
	function controlButton:addChild(child, ...)
		privateData.container:addChild(child, ...)
	end

	function controlButton:removeChild(child, ...)
		privateData.container:removeChild(child, ...)
	end

	function controlButton:removeChildByTag(tag, ...)
		privateData.container:removeChildByTag(tag, ...)
	end

	function controlButton:removeChildByName(name, ...)
		privateData.container:removeChildByName(name, ...)
	end

	function controlButton:getChildByTag(tag)
		return privateData.container:getChildByTag(tag)
	end

	function controlButton:getChildByName(name)
		return privateData.container:getChildByName(name)
	end

	function controlButton:getChildren()
		return privateData.container:getChildren()
	end

	function controlButton:getChildrenCount()
		return privateData.container:getChildrenCount()
	end

	local controlButtonSetCascadeColorEnabled = controlButton.setCascadeColorEnabled
	function controlButton:setCascadeColorEnabled(value)
		controlButtonSetCascadeColorEnabled(controlButton, value)
		privateData.container:setCascadeColorEnabled(value)
	end

	function controlButton:getCurFaceKey()
		return privateData.curFaceKey
	end
	function controlButton:getCurFaceNode()
		return not tolua.isnull(controlButton:getFace(privateData.curFaceKey)) and controlButton:getFace(privateData.curFaceKey) or nil
	end
	privateData.init()

	
	local redDot = false
	function controlButton:addRedDot(args)
		if redDot then
			redDot:setKeys(args.redDotData)
			return
		end
		redDot = UIPublic.newRedDot(params.redDotData)
		local btnSize = controlButton:getContentSize()
		local redOffsetPos = params.redOffsetPos or cc.p(-16, -14)
		redDot:setPosition(btnSize.width + redOffsetPos.x, btnSize.height + redOffsetPos.y)
		controlButton:addChild(redDot)
	end

	function controlButton:setRedDot(args)
		if not redDot then
			controlButton:addRedDot(args)
		else
			redDot:setKeys(args.redDotData)
		end
	end

	if params.redDotData then
		controlButton:addRedDot(params)
	end

	controlButton:setCascadeOpacityEnabled(true)
	return controlButton
end



BASEBUTTON_DEFAULT = {
	paddingX = 15,
	paddingY = 5,
	normalKey = 1,
	pressedKey = 2,
	disabledKey = 3,
	selectedKey = 4,
	style = {
		normal = {
			label = newTextStyle({size = FONT_SIZE_NORMAL, color = htmlColor2C4b("#b5c8df")}),
			skin = {
				-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_yellow"),
				-- scale9Rect = {left = 30, right = 30, top = 12, bottom = 17}
			}
		},
		pressed = {
			label = newTextStyle({size = FONT_SIZE_NORMAL, color = htmlColor2C4b("#b5c8df")}),
			skin = {
				-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_yellow"),
				-- scale9Rect = {left = 30, right = 30, top = 12, bottom = 17}
			}
		},
		disabled = {
			label = newTextStyle({size = FONT_SIZE_NORMAL, color = COLOR_GRAY_C}),
			skin = {
				src = "",
				scale9Rect = {left = 30, right = 30, top = 12, bottom = 17}
			}
		},
		selected = {
			label = newTextStyle({size = FONT_SIZE_NORMAL, color = htmlColor2C4b("#b5c8df")}),
			skin = {
				-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_yellow"),
				-- scale9Rect = {left = 30, right = 30, top = 12, bottom = 17}
			}
		},
	},
}
--[[
创建基础按钮
@params  x, y  			[number]  坐标
@params  anchorPoint  	[cc.p] 描点
@params  width 			[number] 宽度，为nil时，默认显示节点的宽度
@params  height			[number] 高度，为nil时，默认显示节点的高度
@params  isTouchAction	[boolean] 是否触发点击动画， 默认为真
@params  normalNode		[cc.Node]
@params  pressedNode	[cc.Node]
@params  disabledNode	[cc.Node]
@params  selectedNode	[cc.Node]
@params  sharedNode		[cc.Node] 常驻显示节点，不管切换到哪个节点都显示，类似按钮上的文本节点
@params  zoomScale		[number]  缩放大小
@params  zoomTime		[number]  缩放时间
@params  onTouch		[function(event)] 触摸事件, began, moved, ended, cancelled 事件
@params  useCurrentFace [boolean] 是否当前节点的大小
@params  style
			{
				normal = {
					label = {
						artFont
						artWidth, 
						artHeight, 
						font = "MicrosoftYaHei", 
						size = 24, 
						color = "#FFFFFF", 
}, 
					skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal")}
}, 
				pressed = {
					label = {
						font = "MicrosoftYaHei", 
						size = 24, 
						color = "#FFFFFF", 
}, 
					skin = {scale9Rect = {left = 25, right = 25, top = 10, bottom = 10}}
}, 
				disabled = {
					label = {
						font = "MicrosoftYaHei", 
						size = 24, 
						color = "#FFFFFF", 
}, 
					skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
				selected = {
					label = {
						font = "MicrosoftYaHei", 
						size = 24, 
						color = "#FFFFFF", 
}, 
					skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}
]]
function newBaseButton(params)
	if params then
		assert(type(params) == "table", "[UI] newBaseButton() invalid params")
	else
		params = {}
	end

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


	local function tipLog(str)
	--print(168, "newBaseButton: "..str)
	end
	local originParams = params
	params = clone(originParams)

	if type(params.style) ~= "table" then
		params.style = {}
	end
	local normalSkin = nil
	if params.style.normal then
		normalSkin = params.style.normal.skin
	end
	params.style.normal = params.style.normal or clone(BASEBUTTON_DEFAULT.style.normal)
	params.style.normal.label = params.style.normal.label or clone(BASEBUTTON_DEFAULT.style.normal.label)
	params.style.normal.skin = params.style.normal.skin or clone(BASEBUTTON_DEFAULT.style.normal.skin)

	params.style.pressed = params.style.pressed or {}
	params.style.pressed.label = params.style.pressed.label or params.style.normal.label or clone(BASEBUTTON_DEFAULT.style.pressed.label)
	--params.style.pressed.skin = params.style.pressed.skin or normalSkin or clone(BASEBUTTON_DEFAULT.style.pressed.skin)

	params.style.disabled = params.style.disabled or {}
	params.style.disabled.label = params.style.disabled.label or params.style.normal.label or clone(BASEBUTTON_DEFAULT.style.disabled.label)
	--params.style.disabled.skin = params.style.disabled.skin or normalSkin or clone(BASEBUTTON_DEFAULT.style.disabled.skin)

	params.style.selected = params.style.selected or {}
	params.style.selected.label = params.style.selected.label or params.style.normal.label or clone(BASEBUTTON_DEFAULT.style.selected.label)
	--params.style.selected.skin = params.style.selected.skin or normalSkin or clone(BASEBUTTON_DEFAULT.style.selected.skin)

	local baseButton = nil

	local privateData = {}
	privateData.normal = nil
	privateData.selected = nil
	privateData.pressed = nil
	privateData.disable = nil
	privateData.text = nil
	privateData.isArt = false

	function privateData.init()
		params.curFace = BASEBUTTON_DEFAULT.normalKey
		params.createFace = privateData.createFace
		local controlButtonParams = clone(params)
		controlButtonParams.width = nil
		controlButtonParams.height = nil
		controlButtonParams.curFaceNode = params.normalNode
		controlButtonParams.hitLen=params.hitLen
		baseButton = newControlButton(controlButtonParams)

		if tolua.cast(params.sharedNode, "cc.Node") then
			baseButton:addChild(params.sharedNode)
			params.sharedNode:setAnchorPoint(POINT_CENTER)
			privateData.sharedNode = params.sharedNode
		end

		local artLabel = nil
		if params.style.normal.label.artFont then
			artLabel = true
		end

		if artLabel then
			privateData.text = ccui.TextBMFont:create()
			privateData.text:ignoreContentAdaptWithSize(false)
			privateData.isArt = true
		else
			privateData.text = ccui.Text:create()

		end
		privateData.text:setAnchorPoint(POINT_CENTER)
		local render = privateData.text:getVirtualRenderer()
		tolua.cast(render, "cc.label")
		render:setHorizontalAlignment(TEXT_HALIGN_CENTER)
		local container = baseButton:getInnerContainer()
		container:addChild(privateData.text, 1)

		if tolua.cast(params.pressedNode, "cc.Node") then
			baseButton:setFace(BASEBUTTON_DEFAULT.pressedKey, params.pressedNode)
		end
		if tolua.cast(params.disabledNode, "cc.Node") then
			baseButton:setFace(BASEBUTTON_DEFAULT.disabledKey, params.disabledNode)
		end
		if tolua.cast(params.selectedNode, "cc.Node") then
			baseButton:setFace(BASEBUTTON_DEFAULT.selectedKey, params.selectedNode)
		end
		baseButton:setFace(BASEBUTTON_DEFAULT.normalKey)
		privateData.onFaceChange(BASEBUTTON_DEFAULT.normalKey)
	end


	function privateData.initface(style, info)
		local bg = nil
		if style.skin then
			local bgCapInsets, bgOrgSize = skin2CapInsets(params.style.normal.skin)
			if not bgOrgSize then
				bgOrgSize = skin2OrgSize(params.style.normal.skin)
				if not bgOrgSize then
					params.style.normal.skin = BASEBUTTON_DEFAULT.style.normal.skin
					bgCapInsets, bgOrgSize = skin2CapInsets(params.style.normal.skin)
				end
			end
			bg = ccui.Scale9Sprite:create(style.skin.src, cc.rect(0, 0, bgOrgSize.width, bgOrgSize.height), bgCapInsets or cc.rect(0, 0, 0, 0))
			tipLog("face: "..tostring(style.skin.src))
		else
			tipLog(tostring(info).." invalid skin: "..tostring(style.skin))
		end

		return bg
	end

	--获取按钮最终尺寸
	function privateData.getFinalSize(size1, size2, paddingX, paddingY)
		local finalSize = cc.size(0, 0)
		if size1.width > size2.width then
			local gapX = (size1.width - size2.width) / 2
			if gapX >= paddingX then
				finalSize.width = size1.width
			else
				finalSize.width = size2.width + paddingX * 2
			end
		else
			finalSize.width = size2.width + paddingX * 2
		end
		if size1.height > size2.height then
			local gapY = (size1.height - size2.height) / 2
			if gapY >= paddingY then
				finalSize.height = size1.height
			else
				finalSize.height = size2.height + paddingY * 2
			end
		else
			finalSize.height = size2.height + paddingY * 2
		end
		return finalSize
	end

	function privateData.createFace(key)
		--tipLog("face create: "..tostring(key))
		if key == BASEBUTTON_DEFAULT.normalKey then
			if not privateData.normal then
				privateData.normal = privateData.initface(params.style.normal, "normal")
			end
			return privateData.normal
		elseif key == BASEBUTTON_DEFAULT.selectedKey then
			if not privateData.selected then
				privateData.selected = privateData.initface(params.style.selected, "selected")
			end
			return privateData.selected
		elseif key == BASEBUTTON_DEFAULT.disabledKey then
			if not privateData.disable then
				privateData.disable = privateData.initface(params.style.disabled, "disabled")
			end
			return privateData.disable
		elseif key == BASEBUTTON_DEFAULT.pressedKey then
			if not privateData.pressed then
				privateData.pressed = privateData.initface(params.style.pressed, "pressed")
			end
			return privateData.pressed
		end
	end

	function privateData.updateTextStyle(style, default)
		if not params.text or params.text == "" then
			return
		end
		if privateData.isArt then
			if style.artFont then
				privateData.text:setFntFile(style.artFont)
			else
				style.artWidth = style.artWidth or params.style.normal.label.artWidth
				style.artHeight = style.artHeight or params.style.normal.label.artHeight
			end
			privateData.text:setString(params.text)
			local size = privateData.text:getVirtualRendererSize()
			tipLog("textS： "..tostring(size.width).." "..tostring(size.height))
			privateData.text:setContentSize(cc.size(style.artWidth or size.width, style.artHeight or size.height))
			privateData.text:setColor(style.color or COLOR_WHITE)
		else
			privateData.text:setFontName(style.font or default.font)
			privateData.text:setFontSize(style.size or default.size)
			style.color = style.color or default.color
			local renderText = privateData.text:getVirtualRenderer()
			renderText:updateCommomStyle(style)
			tipLog("font: "..tostring(style.font).." df: "..tostring(default.font))

			privateData.text:setString(params.text)
		end

	end
	function privateData.onFaceChange(key)
		if privateData.text then
			if key == BASEBUTTON_DEFAULT.normalKey then
				privateData.updateTextStyle(params.style.normal.label, BASEBUTTON_DEFAULT.style.normal.label)
			elseif key == BASEBUTTON_DEFAULT.selectedKey then
				privateData.updateTextStyle(params.style.selected.label, BASEBUTTON_DEFAULT.style.selected.label)
			elseif key == BASEBUTTON_DEFAULT.disabledKey then
				privateData.updateTextStyle(params.style.disabled.label, BASEBUTTON_DEFAULT.style.disabled.label)
			elseif key == BASEBUTTON_DEFAULT.pressedKey then
				privateData.updateTextStyle(params.style.pressed.label, BASEBUTTON_DEFAULT.style.pressed.label)
			end
		end

		privateData.updateContentSize()
	end

	function privateData.updateContentSize()
		if privateData.text then
			local face = baseButton:getFace()
			local faceSize = (params.useCurrentFace and face or baseButton:getFace(BASEBUTTON_DEFAULT.normalKey)):getContentSize()
			local textSize = privateData.text:getContentSize()
			local finalSize = privateData.getFinalSize(faceSize, textSize, BASEBUTTON_DEFAULT.paddingX, BASEBUTTON_DEFAULT.paddingY)
			finalSize.width = params.width or finalSize.width
			finalSize.height = params.height or finalSize.height
			face:setContentSize(finalSize)
			baseButton:updateContentSize()

			local container = baseButton:getInnerContainer()
			local size = container:getContentSize()
			local style = params.style or {}
			local offsetX = style.x or 0
			local offsetY = style.y or 0
			privateData.text:setPosition(cc.p(size.width / 2 + offsetX, size.height / 2 + offsetY))
			tipLog("size: "..tostring(size.width).." "..tostring(size.height).." textSize: "..tostring(textSize.width).." "..tostring(textSize.height))

			if privateData.sharedNode then
				privateData.sharedNode:setPosition(cc.p(size.width / 2, size.height / 2))
			end
		end
	end

	privateData.init()

	--------------------------------------------------------
	--外部接口
	privateData.setFace = baseButton.setFace
	function baseButton:setFace(key, node)
		privateData.setFace(baseButton, key, node)
		privateData.onFaceChange(key)
	end

	function baseButton:setNormalNode(node)
		baseButton:setFace(BASEBUTTON_DEFAULT.normalKey, node)
	end
	function baseButton:setPressedNode(node)
		baseButton:setFace(BASEBUTTON_DEFAULT.pressedKey, node)
	end
	function baseButton:getNormalNode()
		return baseButton:getFace(BASEBUTTON_DEFAULT.normalKey)
	end
	function baseButton:getPressedNode()
		return baseButton:getFace(BASEBUTTON_DEFAULT.pressedKey)
	end
	function baseButton:setDisabledNode(node)
		baseButton:setFace(BASEBUTTON_DEFAULT.disabledKey, node)
	end
	function baseButton:setSelectedNode(node)
		baseButton:setFace(BASEBUTTON_DEFAULT.selectedKey, node)
	end
	function baseButton:getSelectedNode()
		baseButton:getFace(BASEBUTTON_DEFAULT.selectedKey)
	end
	function baseButton:isNormal()
		return baseButton:getCurFaceKey() == BASEBUTTON_DEFAULT.normalKey
	end

	function baseButton:isPressed(...)
		return baseButton:getCurFaceKey() == BASEBUTTON_DEFAULT.pressedKey
	end

	function baseButton:isDisabled(...)
		return baseButton:getCurFaceKey() == BASEBUTTON_DEFAULT.disabledKey
	end

	function baseButton:isSelected()
		return baseButton:getCurFaceKey() == BASEBUTTON_DEFAULT.selectedKey
	end
	function baseButton:updateTextStyle(key)
		privateData.onFaceChange(key)
	end
	function baseButton:setTitleText(text)
		if privateData.text then
			params.text = text
			privateData.text:setString(text)
			privateData.updateContentSize()
		end
	end

	function baseButton:getTitleRenderer()
		return privateData.text
	end

	local __setEnabled = baseButton.setEnabled
	function baseButton:setEnabled(value)
		if baseButton:isEnabled() ~= value then
			__setEnabled(self, value)
			if value then
				baseButton:setFace(BASEBUTTON_DEFAULT.normalKey)
			else
				baseButton:setFace(BASEBUTTON_DEFAULT.disabledKey)
			end

		end
	end

	privateData.setContentSize = baseButton.setContentSize
	function baseButton:setContentSize(size)
		params.width = size.width
		params.height = size.height
		privateData.updateContentSize()
	end

	return baseButton
end


function newSimpleButton(params)
	if params then
		assert(type(params) == "table", "[UI] newArtButton() invalid params")
	else
		params = {}
	end
	local function tipLog(str)
	--print(168, "newSimpleButton: "..str)
	end

	-- params = clone(params)

	local simpleButton = nil

	local privateData = {}

	function privateData.init()
		local baseButtonParams = clone(params)
		baseButtonParams.onTouch = privateData.onTouch
		baseButtonParams.onClick = nil
		simpleButton = newBaseButton(baseButtonParams)
	end

	function privateData.onTouch(event)
		tipLog(event.name)
		if event.name == "began" then
			simpleButton:setPressedNode()

		elseif event.name == "moved" then

		elseif event.name == "ended" then
			simpleButton:setNormalNode()

			if type(params.onClick) == "function" then
				params.onClick(event.target)
				printStack(params.onClick)
			end

		else
			simpleButton:setNormalNode()
		end

		if type(params.onTouch) == "function" then
			params.onTouch(event)
		end
	end

	privateData.init()

	return simpleButton
end


ARTBUTTON_DEFAULT = {
	style = {
		normal = {
			label = {
				-- artFont = ResManager.getResSub(ResType.FONT, FontType.FNT, "arial"),
				color = COLOR_WHITE,
			},
			-- skin = {src = ResManager.getUIRes(UIType.BUTTON, "default_normal"),
			-- 	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
		},
		pressed = {
			label = {
				color = COLOR_YELLOW,
			},
			-- skin = {src = ResManager.getUIRes(UIType.BUTTON, "default_selected"),
			-- 	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
		},
		disabled = {
			label = {
				color = COLOR_GRAY_C,
			},
			-- skin = {src = ResManager.getUIRes(UIType.BUTTON, "default_disabled"),
			-- 	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
		},
	},
}
--[[
创建艺术字按钮
@param	text		[string]	按钮上的文字
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param  width 		[number] 宽度，为nil时，默认显示节点的宽度
@param  height 	[number] 高度，为nil时， 默认显示节点的高度
@param	anchorPoint	[cc.p]		锚点(如UI.POINT_CENTER)
@param	enabled		[boolean]	是否可用, 为false时显示为disabled状态
@param	zoomScale	[number]	点击放大倍数, 最终scale = scale + zoomScale, 默认值0.1
@param	onTouch		[function]	点击回调函数(按钮上执行的各种事件)
@param	onClick		[function]	点击回调函数(在按钮上按下并且松开)
@param  style
	{
		normal = {
			label = {
				artFont
				artWidth, 
				artHeight, 
				color, 
}, 
			skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal")}
}, 
		pressed = {
			label = {
				artFont
				artWidth, 
				artHeight, 
				color, 
}, 
			skin = {scale9Rect = {left = 25, right = 25, top = 10, bottom = 10}}
}, 
		disabled = {
			label = {
				artFont
				artWidth, 
				artHeight, 
				color, 
}, 
			skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}
]]
function newArtButton(params)
	if params then
		assert(type(params) == "table", "[UI] newArtButton() invalid params")
	else
		params = {}
	end
	local function tipLog(str)
	--print(168, "newArtButton: "..str)
	end

	params = clone(params)
	local style = clone(ARTBUTTON_DEFAULT.style)
	TableUtil.mergeA2B(style, params.style)

	local artButton = nil

	local privateData = {}

	function privateData.init()
		artButton = newBaseButton({
			x = params.x, y = params.y,
			anchorPoint = params.anchorPoint,
			width = params.width,
			height = params.height,
			onTouch = privateData.onTouch,
			text = params.text,
			style = style,
		})

		privateData.setFace = artButton.setFace
	end

	function privateData.onTouch(event)
		tipLog(event.name)
		if event.name == "began" then
			artButton:setPressedNode()

		elseif event.name == "moved" then

		elseif event.name == "ended" then
			artButton:setNormalNode()

			if type(params.onClick) == "function" then
				params.onClick(event.target)
			end

		else
			artButton:setNormalNode()
		end

		if type(params.onTouch) == "function" then
			params.onTouch(event)
		end
	end

	privateData.init()


	function artButton:setFace()

	end
	return artButton
end


SELECTEDBUTTON_DEFAULT = {
	style = {
		normal = {
			label = newTextStyle({
				color = COLOR_WHITE,
			}),
			skin = TABBAR_DEFAULT_HT_NORMAL_SKIN,
		},
		disabled = {
			label = newTextStyle({
				color = COLOR_GRAY_C,
			}),
			skin = TABBAR_DEFAULT_HT_DISABLED_SKIN
		},
		selected = {
			label = newTextStyle({
				size = FONT_SIZE_NORMAL,
				color = COLOR_YELLOW,
			}),
			skin = TABBAR_DEFAULT_HT_SELECTED_SKIN
		},
	},
}
--[[
选择按钮
@param	text		[string]	按钮上的文字
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param  width		[number] 	宽度，为nil时，默认显示节点的宽度
@param  height		[number] 	高度，为nil时， 默认显示节点的高度
@param	anchorPoint	[cc.p]		锚点(如UI.POINT_CENTER)
@param	onChange	[function(event)]	按钮状态改变回调函数
@param	onSelectedClick	 [function(event)]	按钮状态为激活状态时，点击回调函数
@param  style
	{
		normal = {
			label = {
				artFont
				artWidth, 
				artHeight, 
				font = "MicrosoftYaHei", 
				size = 24, 
				color = "#FFFFFF", 
}, 
			skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal")}
}, 
		disabled = {
			label = {
				font = "MicrosoftYaHei", 
				size = 24, 
				color = "#FFFFFF", 
}, 
			skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
		selected = {
			label = {
				font = "MicrosoftYaHei", 
				size = 24, 
				color = "#FFFFFF", 
}, 
			skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}
]]
function newSelectedButton(params)

	if params then
		assert(type(params) == "table", "[UI] newSelectedButton() invalid params")
	else
		params = {}
	end
	local function tipLog(str)
	--print(168, "newSelectedButton: "..str)
	end

	params = clone(params)
	local style = clone(SELECTEDBUTTON_DEFAULT.style)
	style.normal.label.artFont = false
	style.normal.label.artWidth = false
	style.normal.label.artHeight = false
	style.selected.label.artFont = false
	style.selected.label.artWidth = false
	style.selected.label.artHeight = false
	style.disabled.label.artFont = false
	style.disabled.label.artWidth = false
	style.disabled.label.artHeight = false
	style.x = false
	style.y = false
	TableUtil.mergeA2B(params.style, style)

	local selectedButton = nil

	local  privateData = {}
	privateData.isSelected = false
	function privateData.init()

		selectedButton = newBaseButton({
			x = params.x,
			y = params.y,
			anchorPoint = params.anchorPoint,
			isTouchAction = false,
			onTouch = privateData.onTouch,
			width = params.width,
			height = params.height,
			text = params.text,
			style = style,
			normalNode = params.normalNode,
			selectedNode = params.selectedNode,
			disabledNode = params.disabledNode,
			sharedNode = params.sharedNode,
			playSound = params.playSound,
			hitLen= params.hitLen,
		})
		privateData.setFace = selectedButton.setFace
	end

	function privateData.onTouch(event)
		-- print(77, "onTouch")
		if event.name == "began" then
			if not privateData.isSelected then

				selectedButton:updateTextStyle(BASEBUTTON_DEFAULT.selectedKey)
			end
		elseif event.name == "moved" then
		elseif event.name == "ended" then
			if not privateData.isSelected then
				privateData.isSelected = true
				selectedButton:setSelectedNode()
				privateData.onChange(true)

				if params.onUnSelectedClick then
					params.onUnSelectedClick(selectedButton)
				end

			elseif params.onSelectedClick then
				params.onSelectedClick(selectedButton)
			end
		else
			if not privateData.isSelected then
				selectedButton:setNormalNode()
			end
		end
	end

	privateData.init()

	function privateData.onChange(isClick)
		if type(params.onChange) == "function" then
			params.onChange({target = selectedButton, value = privateData.isSelected, isClick = isClick})
		end
	end

	function selectedButton:setSelected(value)
		if type(value) == "boolean" then
			if value ~= privateData.isSelected then
				privateData.isSelected = value
				if privateData.isSelected then
					privateData.setFace(selectedButton, BASEBUTTON_DEFAULT.selectedKey)
				else
					privateData.setFace(selectedButton, BASEBUTTON_DEFAULT.normalKey)
				end
				privateData.onChange()
			end
		else
			tipLog("invalid value: "..tostring(value))
		end

	end
	function selectedButton:isSelected()
		return privateData.isSelected
	end
	return selectedButton
end
