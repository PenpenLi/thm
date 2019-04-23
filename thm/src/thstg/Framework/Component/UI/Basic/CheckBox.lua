module("UI", package.seeall)

CHECK_BOX_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	anchorPoint = UI.POINT_CENTER,
	selected = false,
	enabled = true,
	margin = 10,
	style = {
		skin = {
			bgNormal = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "check_box_bg1"), --未选中状态底图
			cross = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "check_box_sel1"), --选中状态覆盖图
			bgDisabled = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "check_box_bg1"), --不可用状态底图
			crossDisabled = "",--ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "check_box_dis1"), --选中不可用状态
		},
		label = {
			normal = UI.newTextStyle({color = UI.getColorHtml("#394847")}),
			disabled = UI.newTextStyle({color = UI.COLOR_GRAY_9}),
		},
		labelOffset = {x = -5, y = 0},
	}
}


--[[
CheckBox组件
@param  tag             [number]        tag 自定义的ID,可用于唯一标示
@param  x				[number]     	X坐标
@param  y				[number]	 	Y坐标
@param	anchorPoint		[cc.p]			锚点(如UI.POINT_LEFT_BOTTOM)
@param  onChange		[function]   	点击checkBox回调函数，如：function onChange(sender, isSelected) end
@param  selected		[boolean]    	创建时是否设置选中状态
@param  text            [string]        文本
@param	style			[table]			样式
	{
		skin = {
			bgNormal = ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "bg_normal"), --未选中状态底图
			bgDisabled = ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "bg_disabled"), --不可用状态底图
			cross = ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "cross"), --选中状态覆盖图
			crossDisabled = ResManager.getResSub(ResType.UIBASE,UIBaseType.CHECK_BOX, "cross_disabled"), --选中不可用状态
}, 
		label = {
			normal = UI.newTextStyle(), 文本皮肤
			disabled = UI.newTextStyle({color = UI.COLOR_GRAY_9}), 
}, 
		labelOffset = {x = 5, y = 0}, 标签偏移
}
example:
local function onChange(sender, isSelected)
	printf("~~~111~~~ sender:%s isSelected:%s", tostring(sender), tostring(isSelected))
end

local cb1 = UI.newCheckBox({
	x = 300, y = 240, 
	onChange = onChange, 
	enabled = false, 
	selected = true, 
})
parent:addChild(cb1)
]]

function newCheckBox(params)
	if params then
		assert(type(params) == "table", "[UI] newCheckBox() invalid params")
	else
		params = {}
	end

	local finalParams = clone(CHECK_BOX_DEFAULT_PARAMS)
	
	if not params.tag then
		params.tag = 0
	end

	TableUtil.mergeA2B(params, finalParams)

	local node = UI.newHBox({
		autoSize = params.autoSize,
		x = finalParams.x, 
		y = finalParams.y,
		margin = finalParams.margin,
		anchorPoint = finalParams.anchorPoint,
		linearGravity = ccui.LinearGravity.centerVertical,
	})
	local checkBox = ccui.CheckBox:create(
		finalParams.style.skin.bgNormal, 
		finalParams.style.skin.cross
	)

	-- 暂时没资源
	checkBox:loadTextureBackGroundDisabled(finalParams.style.skin.bgDisabled)
	checkBox:loadTextureFrontCrossDisabled(finalParams.style.skin.crossDisabled)

	checkBox:setSelected(finalParams.selected)

	local function onChange(sender, eventType)
		if type(params.onChange) == "function" then
			params.onChange(sender, eventType == ccui.CheckBoxEventType.selected, params.tag)
			printStack(params.onChange)
		end
	end
	checkBox:addEventListener(onChange)

	local checkBoxSize = checkBox:getContentSize()
	node:addChild(checkBox)
	node:setContentSize(checkBoxSize)
	local __setEnabled = checkBox.setEnabled

	----public接口------------

	--设置是否可点击
	function node:setEnabled(value)
		if checkBox:isEnabled() ~= value then
			__setEnabled(checkBox, value)

			if checkBox.labelControlBtn then
				checkBox.labelControlBtn:setEnabled(value)
			end
			if checkBox.label and not params.isRichText then
				--------------------先屏蔽掉吧------------------------
				if value then
					checkBox.label:updateStyle(finalParams.style.label.normal)
				else
					checkBox.label:updateStyle(finalParams.style.label.disabled)
				end
			end
		end
	end
	
	function node:isEnabled()
		return checkBox:isEnabled()
	end

	--
	function node:setLabelZoomScale(value)
		if checkBox.labelControlBtn then
			checkBox.labelControlBtn:setZoomScale(value)
		end
	end

	-- local function (...)
	-- 	-- body
	-- end
	--变更文本
	function node:setText(str)
		if not checkBox.label then

			if params.isRichText then
				checkBox.label = UI.newRichText({
					text = params.text,
					x = checkBoxSize.width + finalParams.style.labelOffset.x,
					y = checkBoxSize.height / 2 + finalParams.style.labelOffset.y,
					anchorPoint = UI.POINT_LEFT_CENTER,
					style = finalParams.style.label.normal,
				})
			else
				checkBox.label = UI.newLabel({
					text = params.text,
					x = checkBoxSize.width + finalParams.style.labelOffset.x,
					y = checkBoxSize.height / 2 + finalParams.style.labelOffset.y,
					anchorPoint = UI.POINT_LEFT_CENTER,
					style = finalParams.style.label.normal,
				})
			end
			checkBox.labelControlBtn = UI.newControlButton({
				curFaceNode = checkBox.label,
				onClick = function (...)
					node:setSelected(not checkBox:isSelected())
				end
			})
			node:addLayoutChild(checkBox.labelControlBtn, {margin = {left = finalParams.style.labelOffset.x, top = finalParams.style.labelOffset.y}})
		end

		checkBox.label:setText(str)
		if checkBox.labelControlBtn then
			checkBox.labelControlBtn:updateContentSize()
		end
		node:forceDoLayout()
	end

	--------------------
	if type(params.text) == "string" and params.text ~= "" then
		node:setText(params.text)
	end
	node:setEnabled(finalParams.enabled)


	--[[
	value:
	true - 选中状态
	false - 不选中状态
	
	change:
	nil - 若和之前状态相同，则不触发onChange
	true - 必定onChange
	false - 不触发onChange
	]]
	function node:setSelected(value, change)

		if change == nil then
			local isSelected = checkBox:isSelected()
			if isSelected == value then
				return
			end
			checkBox:setSelected(value)
			if type(params.onChange) == "function" then
				params.onChange(checkBox, value==true, params.tag)
			end
		
		elseif change == true then
			checkBox:setSelected(value)
			if type(params.onChange) == "function" then
				params.onChange(checkBox, value==true, params.tag)
			end

		elseif change == false then
			checkBox:setSelected(value)
		end
		
	end

	function node:isSelected()
		return checkBox:isSelected()
	end

	return node
end
