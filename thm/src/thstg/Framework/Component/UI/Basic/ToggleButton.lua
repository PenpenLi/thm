module("THSTG.UI", package.seeall)

TOGGLEBUTTON_DEFAULT = {
	size = cc.size(60, 60),
	style = {
		toggle = {
			normal = {
				skin = TABBAR_DEFAULT_HB_SELECTED_SKIN,
			},
			pressed = {
				skin = TABBAR_DEFAULT_HB_SELECTED_SKIN,
			},
			disabled = {
				skin = TABBAR_DEFAULT_HB_DISABLED_SKIN,
			}
		},
		distoggle = {
			normal = {
				skin = TABBAR_DEFAULT_HB_NORMAL_SKIN,
			},
			pressed = {
				skin = TABBAR_DEFAULT_HB_NORMAL_SKIN,
			},
			disabled = {
				skin = TABBAR_DEFAULT_HB_DISABLED_SKIN,
			}
		},
	},
}

--[[
@params x, y [number]  坐标
@params anchorPoint  [cc.p] 描点
@params isToggle     [boolean] 状态
@params enabled      [boolean] 是否可点击
@params toggleNode   [cc.Node]  自定义节点，显示在button皮肤上
@params distoggleNode   [cc.Node]  自定义节点，显示在button皮肤上
@params width        [number]   button的宽度
@params height 		 [number]   button的高度, 不填使用皮肤原图大小
@params onClick      [function(sender, isToggle, toggleCustomNode, distoggleCustomNode)]
@params style = {[table]   皮肤
				toggle = {isToggle == true 对应的皮肤
						normal = {
							skin = TABBAR_DEFAULT_VL_SELECTED_SKIN, 
}, 
						pressed = {
							skin = TABBAR_DEFAULT_VL_SELECTED_SKIN, 
}, 
						disabled = {
							skin = TABBAR_DEFAULT_VL_SELECTED_SKIN, 
}
}, 
				distoggle = {isToggle == false 对应的皮肤
								normal = {
									skin = TABBAR_DEFAULT_VL_NORMAL_SKIN, 
}, 
								pressed = {
									skin = TABBAR_DEFAULT_VL_NORMAL_SKIN, 
}, 
								disabled = {
									skin = TABBAR_DEFAULT_VL_NORMAL_SKIN, 
}
}, 
}, 

]]
function newToggleButton(params)
	if params then
		assert(type(params) == "table", "[UI] newToggleButton() invalid params")
	else
		params = {}
	end
	params = clone(params)
	local function tipLog(str)
		print("newToggleButton: "..str)
	end

	local finalParams = {
		x = 0, y = 0,
		anchorPoint = clone(POINT_CENTER),
		enabled = true,
		isToggle = true,
	}
	THSTG.TableUtil.mergeA2B(params, finalParams)

	local togglebutton = ccui.Widget:create()

	local privateData = {}
	privateData.item = {}
	privateData.customNode = {}

	function privateData.init()
		togglebutton:setUnifySizeEnabled(true)

		local toggleStyle = TOGGLEBUTTON_DEFAULT.style.toggle
		local distoggleStyle = TOGGLEBUTTON_DEFAULT.style.distoggle
		if params.style then
			if params.style.toggle then
				toggleStyle = params.style.toggle
			end
			if params.style.distoggle then
				distoggleStyle = params.style.distoggle
			end
		end

		local toggleItem = newSimpleButton({
			anchorPoint = POINT_LEFT_BOTTOM,
			style = toggleStyle,
			onClick = privateData.onClick,
			width = params.width, height = params.height
		})
		local distoggleItem = newSimpleButton({
			anchorPoint = POINT_LEFT_BOTTOM,
			style = distoggleStyle,
			onClick = privateData.onClick,
			width = params.width, height = params.height
		})
		if params.toggleNode then
			local image = params.toggleNode
			toggleItem:addChild(image)
			privateData.customNode[true] = image
			local ar = image:getAnchorPoint()
			local cs = image:getContentSize()
			--image:setPosition(ar.x * cs.width, ar.y * cs.height)
		end
		if params.distoggleNode then
			local image = params.distoggleNode
			distoggleItem:addChild(image)
			privateData.customNode[false] = image
			local ar = image:getAnchorPoint()
			local cs = image:getContentSize()
			--image:setPosition(ar.x * cs.width, ar.y * cs.height)
		end
		togglebutton:addChild(toggleItem)
		togglebutton:addChild(distoggleItem)
		privateData.item[true] = toggleItem
		privateData.item[false] = distoggleItem

		--初始化
		privateData.setToggle(finalParams.isToggle)
		privateData.setEnable(finalParams.enabled)

		togglebutton:setPosition(cc.p(finalParams.x, finalParams.y))
		togglebutton:setAnchorPoint(finalParams.anchorPoint)
	end

	--[[点击事件]]
	function privateData.onClick(sender)
		--tipLog("click")
		if not params.noAutoChange then
			privateData.onStateChange(not finalParams.isToggle)
		end
		if type(params.onClick) == "function" then
			params.onClick(togglebutton, finalParams.isToggle, privateData.customNode[finalParams.isToggle], privateData.customNode[not finalParams.isToggle])
			printStack(params.onClick)
		end
	end

	--[[状态改变]]
	function privateData.onStateChange(isToggle)
		finalParams.isToggle = isToggle
		privateData.item[finalParams.isToggle]:setVisible(true)
		privateData.item[not finalParams.isToggle]:setVisible(false)
		togglebutton:setContentSize(privateData.item[finalParams.isToggle]:getContentSize())
		if params.onChange then
			params.onChange(isToggle)
		end
	end

	function privateData.setEnable(value)
		finalParams.enabled = value
		privateData.item[true]:setEnabled(finalParams.enabled)
		privateData.item[false]:setEnabled(finalParams.enabled)
	end

	function privateData.setToggle(isToggle)
		privateData.onStateChange(isToggle)
	end
	----------------------------------------------------------
	--外部接口
	--[[设置状态
	--isToggle  [boolean]
	]]
	function togglebutton:setToggle(isToggle)
		if type(isToggle) == "boolean" then
			privateData.setToggle(isToggle)
		end
	end

	--[[获取显示状态]]
	function togglebutton:getToggle()
		return finalParams.isToggle
	end

	--[[设置是否可点击
	--isenable [boolean]
	]]
	function togglebutton:setToggleEnable(isenable)
		if type(isenable) == "boolean" then
			privateData.setEnable(isenable)
		end
	end

	--[[获取是否可点击]]
	function togglebutton:getToggleEnable()
		return finalParams.enabled
	end

	----------------------------------------------------------
	privateData.init()

	return togglebutton
end
