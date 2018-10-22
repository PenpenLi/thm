			
module("UIPublic", package.seeall)

--[[创建带tabBar的窗口,例如排行榜窗口
--params  winParams  [table] 窗口参数
--params  tabBarParams   [table] tabBar参数 
			{
				tabBarSrc  参见newRoleTabBar
				或
				dataProvider = false, 参见newTabBar的dataprovider
				dataProviderTitle = false, 按键对应的窗口标题，可选
				tabBarOffsetX  [number]  tabbar相对于窗口的X方向偏移，[可选]
				tabBarOffsetY  [number]  tabbar相对于窗口的Y方向偏移， [可选]
				style = {自定义tabbar样式，[可选]。
					normal = {
						label = {}, 
						skin = {
							src = ResManager.getUIRes(UIType.TAB_BAR, "tab_base_sel"), 
							scale9Rect = {left = 7, right = 7, top = 5, bottom = 5}
}, 
}, 
					pressed = {
						label = {}, 
						skin = {
							src = ResManager.getUIRes(UIType.TAB_BAR, "tab_base_normal"), 
							scale9Rect = {left = 7, right = 7, top = 5, bottom = 5}
}, 
}
}, 
				lineSkin = {--分割线的样式，[可选]。
					src = ResManager.getUIRes(UIType.WINDOW, "sep_line10"), 
					scale9Rect = {left = 5, right = 5, top = 5, bottom = 5}, 
}, 
				lineHeight  [number]   分割线高度，[可选]
}
--params  onChange  [function(target, curIndex, lastIndex)]点击tarbbar回调
]]


-- 对应text转换成图片
local titleIconMap = {
	-- [Language.getString(102030)] = ResManager.getRes(ResType.WINDOW_TITLE_ICON, "title_icon_role"), --人物模块
	-- [Language.getString(110350)] = ResManager.getRes(ResType.WINDOW_TITLE_ICON, "title_icon_assist"), --设置
	}

-- 窗口tabBar
function newWindowWithTabBar(params)
	params = params or {}
	local tabBarSrc = params.tabBarParams.tabBarSrc
	local winParams = {
		isLeft = params.isLeft,
		onClose = false,
		title = "",
		blackScreen = true,
		style = {
			titleIcon = titleIconMap[ params.winParams and  params.winParams.title or ""] or ResManager.getRes(ResType.PLAYER, "player_head"),
		},
		isInnerBorderFrame = true,

	}
	THSTG.TableUtil.unionA2B(params.winParams, winParams)

	local win = THSTG.UI.newWindow(winParams)
	local winSize = win:getContentSize()

	-- tabBar位置
	local tabBarOffsetX = params.tabBarParams.tabBarOffsetX or 0
	local tabBarOffsetY = params.tabBarParams.tabBarOffsetY or 0
	local tarBarOffsetH = params.tabBarParams.tarBarOffsetH or 0
	local tabBarPos = cc.p(
		winSize.width + 8 + tabBarOffsetX,
		winSize.height - 50 + tabBarOffsetY
	)
	local tabBarAnchorPoint = THSTG.UI.POINT_RIGHT_TOP
	local layerStackPos = cc.p(0, 0)
	if params.isLeft then
		tabBarPos = cc.p(tabBarOffsetX, winSize.height - 50 + (tabBarOffsetY or 0))
		tabBarAnchorPoint = THSTG.UI.POINT_LEFT_TOP
		layerStackPos = cc.p(314, 20)
	end
	if params.layerStack then
		win:addChild(params.layerStack)
		layerStackPos = params.layerStackPos or layerStackPos
		params.layerStack:setPosition(layerStackPos)
	end

	local tabBarHeight = params.tabBarHeight or math.max(0, winSize.height - 75 - tarBarOffsetH)
	local tabBarParams = nil
	tabBarParams = {
		tabBarSrc = false,
		tabBarKey = false,
		dataProvider = false,
		dataProviderTitle = false,
		isAccordingTabBar = false,
		ignoreAutoSelect = true,
		isFoldedNoClick = true,
		selectedIndex = 1,
		isBMFontLabel = false,
		namePosX = false,
		lineSkin = {--线的样式
			src = ResManager.getUIRes(UIType.WINDOW, "sep_line10"),
			scale9Rect = {left = 5, right = 5, top = 5, bottom = 5},
		},
		lineHeight = false,
		lineWidth = false,
		-- 默认图片大小
		itemWidth = false,
		itemHeight = false,
		--width = 135,
		tabBarHeight = tabBarHeight,
		x = tabBarPos.x,
		y = tabBarPos.y,
		anchorPoint = tabBarAnchorPoint,
		direction = THSTG.UI.TABBAR_DIRECTION_VL,
		itemGap = 1,
		isPlaySound = true,
		onChange = function (target, curIndex, lastIndex, tabBarItemKey)
			local tabBarSrc = tabBarParams.tabBarSrc or {}
			local iteminfo = tabBarSrc[curIndex]
			if iteminfo and iteminfo.forceRefreshName then
				win:setTitle(iteminfo.title or iteminfo.name or "")
			else
				tabBarSrc = tabBarParams.dataProviderTitle or {}
				iteminfo = tabBarSrc[curIndex]
				if iteminfo then
					win:setTitle(iteminfo)
				end
			end
			if params.onChange then
				params.onChange(target, curIndex, lastIndex, tabBarItemKey)
				-- printStack(params.onChange)
			end
		end,
		style = false,
	}

	THSTG.TableUtil.mergeA2B(params.tabBarParams, tabBarParams)
	tabBarParams.style = tabBarParams.style or nil
	tabBarParams.redDotPos = params.tabBarParams.redDotPos
	local tabBar
	if tabBarParams.isAccordingTabBar then
		tabBarParams.onChange = function (target, curIndex, lastIndex, tabBarItemKey)
			if params.onChange then
				params.onChange(target, curIndex, lastIndex, tabBarItemKey)
			end
		end
		tabBar = UIPublic.newAccordingTabBar(tabBarParams)

	else

		local lineImg
		if params.isLeft then
			-- lineImg = THSTG.UI.newImage({
			-- 	x = 0,
			-- 	y = 1,
			-- 	width = tabBarParams.lineWidth or 110,
			-- 	height = tabBarParams.lineHeight or winSize.height - 28,
			-- 	anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
			-- 	style = tabBarParams.lineSkin,
			-- })
		else
			lineImg = THSTG.UI.newImage({
				x = winSize.width,
				y = 1,
				width = tabBarParams.lineWidth or 112,
				height = tabBarParams.lineHeight or winSize.height - 28,
				anchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
				style = tabBarParams.lineSkin,
			})
			win:addChild(lineImg, 2)
		end
		tabBar = UIPublic.newRoleTabBar(tabBarParams)
	end
	win:addChild(tabBar, 2)

	local function onDelTab(_, e, args)
		if args.moduleType == params.moduleType then
			if not tolua.isnull(params.layerStack) then
				tabBar:removeItemByIndex(args.index, args.defaultIndex)
				if tolua.isnull(tabBar:getItem(0)) then
					params.layerStack:hide()
				else
					params.layerStack:show()
				end
			end
		end
	end

	local function onAddTab(_, e, args)
		if args.moduleType == params.moduleType then
			if not tolua.isnull(params.layerStack) then
				-- 有就加不了，暂时不支持插入
				if tolua.isnull(tabBar:getItem(args.index-1)) then
					tabBar:addItem(args.index)
					params.layerStack:show()
					if args.selectIndex then
						tabBar:setSelectedIndex(args.selectIndex, args.update)
					end
				end
			end
		end
	end

	local function onJumpTab(_, e, args)
		if args.moduleType == params.moduleType then
			tabBar:setSelectedIndex(args.index, args.update)
		end
	end
	
	function tabBar:selectTabWithRedPointFirst()
		--选中第一个带红点的tarBar
		local index = 1
		for k, v in ipairs(tabBarSrc) do
			local redDotData = v.redDotData or {}
			local status = Cache.redDotCache.getStatus(redDotData)
			if status then
				index = k
				break
			end
		end
		tabBar:setSelectedIndex(index, true)
	end

	if params.moduleType then
		local eventNode = THSTG.UI.newNode()
		win:addChild(eventNode)
		eventNode:onNodeEvent("enter", function ()
			Dispatcher.addEventListener(EventType.PUBLIC_WINDOW_DEL_TAB, onDelTab)
			Dispatcher.addEventListener(EventType.PUBLIC_WINDOW_ADD_TAB, onAddTab)
			Dispatcher.addEventListener(EventType.PUBLIC_WINDOW_TAB_JUMP, onJumpTab)
		end)
		eventNode:onNodeEvent("exit", function ()
			Dispatcher.removeEventListener(EventType.PUBLIC_WINDOW_DEL_TAB, onDelTab)
			Dispatcher.removeEventListener(EventType.PUBLIC_WINDOW_ADD_TAB, onAddTab)
			Dispatcher.removeEventListener(EventType.PUBLIC_WINDOW_TAB_JUMP, onJumpTab)
		end)
	end
	return win, tabBar
end

-- 单例窗口
function newWindowInstance(args)
	args = args or {}

	local M = {}

	local function createInstance(params,...)
		local node = M.create(params,...)
		node:enableNodeEvents()
		function node:onCleanup()
			M.node = false
		end
		return node
	end

	function M.show(params,...)
		params = params or {}
		if params.force then
			M.close()
		end
		if tolua.isnull(M.node)then
			M.node = createInstance(params,...)
			local father = args.fatherLayer or params.fatherLayer or LayerManager.windowLayer
			if params.zorder then
				father:addChild(M.node, params.zorder)
			else
				father:addChild(M.node)
			end
		end
	end

	function M.close()
		if not tolua.isnull(M.node) then
			M.node:removeFromParent()
		end
		M.node = false
	end

	function M.isShow()
		return not tolua.isnull(M.node)
	end

	function M.create(params)

	end

	return M
end

--[[创建物品购买界面, 例如商城购买界面
--params value 参考newMallItem value
--params.enableInput 为false表示不能输入，默认为ture
]]
function newBuyWindow(params)

	require("Game.THSTG.UI.Public.Item")
	params = params or {}

	local sellData = params.sell_data
	local priveValue = 0
	local maxNum = params.maxNum or 99
	local winW = 682
	local winH = 413
	local viewH = winH - 30
	local win = THSTG.UI.newWindow({
		width = winW, height = winH,
		title = Language.getString(151100),
		titleType = 2,
		blackScreen = true,
		onClose = function (sender)
			if params.onClose then
				params.onClose(sender)
			end
		end
	})

	local padding = 10
	local frame1 = THSTG.UI.newFrame({
		w = winW * 0.45-padding * 3,
		h = (viewH - padding * 2),
		x = padding,
		y = padding,
		style = 2,
	})
	win:addChild(frame1)

	local frame2 = THSTG.UI.newFrame({
		w = winW * 0.55 - padding * 0.5,
		h = (viewH - padding * 2),
		x = padding * 2 + winW * 0.45-padding * 3,
		y = padding,
		style = 2,
	})
	win:addChild(frame2)

	local totalPayPos = cc.p(30, 181)
	local amountY = 150
	local tipX = 20
	local totalPayTip = THSTG.UI.newLabel({
		text = Language.getString(151101),
		x = tipX, y = amountY,
		anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
		style = {
			size = THSTG.UI.FONT_SIZE_NORMAL,
			color = THSTG.UI.htmlColor2C3b("#59552a")
		}
	})
	local inputW = 160
	local inputH = 35
	local inputX = 110
	win:addChild(totalPayTip)
	local payFrame = THSTG.UI.newFrame({
		x = inputX,
		y = amountY,
		style = 2,
		w = inputW,
		h = inputH,
	})
	payFrame:setAnchorPoint(0, 0.5)
	win:addChild(payFrame)

	local totalPay = THSTG.UI.newLabel({
		x = 30, y = inputH / 2,
		anchorPoint = ccp(0, 0.5),
		style = {
			size = THSTG.UI.FONT_SIZE_NORMAL,
			color = THSTG.UI.htmlColor2C3b("#394847")
		}
	})
	payFrame:addChild(totalPay)

	local moneyIcon = THSTG.UI.newSprite({
		-- width = 28,
		-- height = 28,
		x = inputW  - 20,
		y = inputH / 2,
		anchorPoint = THSTG.UI.POINT_CENTER,
		src = ResManager.getMoneyIcon(sellData.unit or 1),
	})
	payFrame:addChild(moneyIcon)

	local function setTotalPay(value)
		totalPay:setString(value)
	end

	local numY = 230
	local numTip = THSTG.UI.newLabel({
		x = tipX,
		y = numY,
		anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
		text = Language.getString(151102),
		style = {
			size = THSTG.UI.FONT_SIZE_NORMAL,
			color = THSTG.UI.htmlColor2C3b("#59552a")
		}
	})
	win:addChild(numTip)

	local numFrame = THSTG.UI.newFrame({
		x = inputX,
		y = numY,
		style = 10,
		w = inputW,
		h = inputH,
	})
	numFrame:setAnchorPoint(0, 0.5)
	win:addChild(numFrame)
	local buyNumValue = THSTG.UI.newLabel({
		x = inputW / 2, y = inputH / 2,
		anchorPoint = THSTG.UI.POINT_CENTER,
		style = {
			size = THSTG.UI.FONT_SIZE_NORMAL,
			color = THSTG.UI.htmlColor2C3b("#394847")
		}
	})
	numFrame:addChild(buyNumValue)


	local item = UIPublic.newMallItem({
		x = 20,
		y = viewH - 60,
	})
	win:addChild(item)

	local fgPos = cc.p(282, 10)
	local fg = THSTG.UI.newFrame({
		x = fgPos.x, y = fgPos.y, h = 338, style = 3,
	})
	win:addChild(fg)

	local buyBtnPos = cc.p(75, 33)
	local rightPartCenter = frame2:getPositionX() + frame2:getContentSize().width / 2

	local input = THSTG.UI.newKeypad({
		x = rightPartCenter, y = viewH / 2-20,
		gap = {
			width = 10,
			height = 20
		},
		keySize = {
			width = 75,
			height = 70,
		},
		enableInput = (params.enableInput == false) ~= true,
		anchorPoint = ccp(0.5, 0.5),
		onClick = function (node, value)
			print(value)
			buyNumValue:setString(value)
			setTotalPay(tostring(tonumber(value) * tonumber(priveValue)))
		end
	})
	local inputS = input:getContentSize()
	win:addChild(input)
	local inputTipBg = THSTG.UI.newScale9Sprite{
		x = rightPartCenter,
		y = viewH - 40,
		width = 300,
		style = {
			src = ResManager.getRes(ResType.PUBLIC, "img_title_1"),
			scale9Rect = {left = 45, right = 45, top = 10, bottom = 10}
		},
	}
	win:addChild(inputTipBg)
	local inputTip = THSTG.UI.newLabel({
		x = rightPartCenter,
		y = viewH -40,
		anchorPoint = THSTG.UI.POINT_CENTER,
		text = Language.getString(151103),
		style = {
			size = THSTG.UI.FONT_SIZE_BIG,
			color = THSTG.UI.htmlColor2C3b("#375690")
		}
	})
	win:addChild(inputTip)

	local buyBtn = THSTG.UI.newButton({
		src = ResManager.getUIRes(UIType.BUTTON, "btn_big_yellow"),
		x = buyBtnPos.x, y = buyBtnPos.y,
		anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		width = 135,
		height = 52,
		yellowStyle = 1,
		text = params.buyText or Language.getString(135008),
		onClick = function (sender)
			if type(params.onBuy) == "function" then
				local amount = buyNumValue:getText()
				params.onBuy(tonumber(amount))
			end

			win:removeFromParent()
		end
	})
	win:addChild(buyBtn)

	local function reset(value)
		buyNumValue:setString(value.amount or 1)
		input:clearValue()

		local offer = value.getOffer and value.getOffer() or value.offer
		priveValue = offer ~= 0 and offer or value.price
		setTotalPay(tostring(tonumber(value.amount or 1) * tonumber(priveValue)))
		input:setMaxValue(maxNum)
	end

	function win:updateItem(value)

		reset(value)
		item:updateItem(value)

	end

	win:updateItem(sellData)

	--指引相关,请勿修改
	function win:getGuideButton()
		return buyBtn
	end
	return win
end

function newRedWindow(params)

	local node, tabBar

	local winSize = cc.size(1058, 618)
	local winParams = {
		x = display.cx,
		y = display.cy - 30,
		width = winSize.width,
		height = winSize.height,

		titleType = THSTG.UI.WINDOW_TITLE_TYPE.IMAGE,
		title = params.winParams.title,

		blackScreen = true,
		style = {
			bgSkin = {
				src = ResManager.getRes(ResType.MARRY, "img_window4"),
				scale9Rect = {left = 450, right = 450, top = 270, bottom = 270, },
			},

			closeBtnSkin = {
				src = ResManager.getRes(ResType.ACTIVITY, "celebration_close_btn"),
				offsetX = -0,
				offsetY = -38,
			},

			titleSkin = {
				offsetY = 5
			},

			innerSkin = {
				src = ResManager.getRes(ResType.MARRY, "img_bg_3"),
			}
		},
		onClose = params.onClose or function ()
			node:removeFromParent()
		end
	}

	local tabBarParams = {
		isBMFontLabel = true,
		style = {
			normal = {
				label = {
					font = ResManager.getResSub(ResType.FONT, FontType.FNT, "activityyeqian"),
					additionalKerning = -6,
				},
				skin = {
					src = ResManager.getUIRes(UIType.TAB_BAR, "tab_normal_6"),
					scale9Rect = {left = 7, right = 7, top = 5, bottom = 5}
				},
			},
			pressed = {
				label = {
					font = ResManager.getResSub(ResType.FONT, FontType.FNT, "activityyeqian_sel"),
					additionalKerning = -6,
				},
				skin = {
					src = ResManager.getUIRes(UIType.TAB_BAR, "tab_selected_6"),
					scale9Rect = {left = 7, right = 7, top = 5, bottom = 5}
				},
			}
		},
		lineSkin = {
			src = ResManager.getUIRes(UIType.WINDOW, "sep_line19"),
			scale9Rect = {left = 5, right = 5, top = 5, bottom = 5},
		},
		lineWidth = 123,
		lineHeight = 577,

		itemWidth = 126,
		redDotPos = cc.p(105, 60),
		
		tabBarOffsetY = -28,
		tabBarOffsetX = 0,
		
		tabBarSrc = params.tabBarParams.tabBarSrc,
		-- dataProvider =  params.tabBarParams and params.tabBarParams.dataProvider,
		-- onChange =  params.tabBarParams and params.tabBarParams.onChange,
	}


	node, tabBar = THSTG.UI.newSimpleWindowWithTabBar({
		-- tabBar参数
		tabBarParams = tabBarParams,

		-- 数据
		layerStack = params.layerStack,

		-- 窗口参数
		winParams = winParams,

		-- 选择
		onChange = params.onChange or function (menu, curIndex, preIndex, tabBarItemKey)
			preIndex = preIndex or 1
			layerStack:setSelectedIndex(tabBarItemKey)
		end,
	})


	local titleImg = THSTG.UI.newImage({
		x = winSize.width / 2,
		y = winSize.height + 15,
		width = winSize.width + 135,
		height = 95,
		anchorPoint = THSTG.UI.POINT_CENTER_TOP,
		style = {
			src = ResManager.getRes(ResType.MARRY, "img_window_title"),
			scale9Rect = {left = 500, right = 500, top = 45, bottom = 45},
		}
	})
	node:addChild(titleImg, 2)

	local centerImg = THSTG.UI.newSprite({
		x = winSize.width / 2,
		y = winSize.height + 40,
		anchorPoint = THSTG.UI.POINT_CENTER_TOP,
		src = ResManager.getRes(ResType.MARRY, "img_stripe2"),
	})
	node:addChild(centerImg, 2)

	return node, tabBar
end
