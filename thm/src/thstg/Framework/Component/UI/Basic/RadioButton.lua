module("THSTG.UI", package.seeall)

RADIO_BUTTON_DEFAULT_PARAMS = {
	x = 0,
	y = 0,
	anchorPoint = THSTG.UI.POINT_CENTER,
	selected = false,
	enabled = true,
	style = {
		skin = {
			bgNormal = "",-- ResManager.getUIRes(UIType.RADIO_BUTTON, "bg_normal"), --未选中状态底图
			bgDisabled ="",-- ResManager.getUIRes(UIType.RADIO_BUTTON, "bg_disabled"), --不可用状态底图
			cross = "",--ResManager.getUIRes(UIType.RADIO_BUTTON, "cross"), --选中状态覆盖图
			crossDisabled ="",-- ResManager.getUIRes(UIType.RADIO_BUTTON, "cross_disabled"), --选中不可用状态
		},
		label = {
			normal = THSTG.UI.newTextStyle(),
			disabled = THSTG.UI.newTextStyle({color = THSTG.UI.COLOR_GRAY_9}),
		},
		labelOffset = {x = 5, y = 0},
	}
}
--[[
RadioButton组件
@param  x				[number]     	X坐标
@param  y				[number]	 	Y坐标
@param	anchorPoint		[cc.p]			锚点(如UI.POINT_LEFT_BOTTOM)
@param  onChange		[function]   	点击RadioButton回调函数，如：function onChange(sender, isSelected) end
@param  selected		[boolean]    	创建时是否设置选中状态
@param	style			[table]			样式
@example
local function onChange(sender, isSelected)
	printf("~~~111~~~ sender:%s isSelected:%s", tostring(sender), tostring(isSelected))
end

local cb1 = THSTG.UI.newRadioButton({
	x = 300, y = 240, 
	onChange = onChange, 
	enabled = false, 
	selected = true, 
})
parent:addChild(cb1)
]]
function newRadioButton(params)
	if params then
		assert(type(params) == "table", "[UI] newRadioButton() invalid params")
	else
		params = {}
	end

	local finalParams = clone(RADIO_BUTTON_DEFAULT_PARAMS)
	THSTG.TableUtil.mergeA2B(params, finalParams)
	
	local radioButton = ccui.RadioButton:create(finalParams.style.skin.bgNormal, finalParams.style.skin.cross)
	radioButton:loadTextureBackGroundDisabled(finalParams.style.skin.bgDisabled)
	radioButton:loadTextureFrontCrossDisabled(finalParams.style.skin.crossDisabled)


	radioButton:setSelected(finalParams.selected)
	radioButton:setPosition(finalParams.x, finalParams.y)
	radioButton:setAnchorPoint(finalParams.anchorPoint)

	local function onChange(sender, eventType)
		if type(params.onChange) == "function" then
			params.onChange(sender, eventType == ccui.CheckBoxEventType.selected)
		end
	end
	radioButton:addEventListener(onChange)

	local radioButtonSize = radioButton:getContentSize()

	local __setEnabled = radioButton.setEnabled

	----public接口------------

	--设置是否可点击
	function radioButton:setEnabled(value)
		if self:isEnabled() ~= value then
			__setEnabled(self, value)

			if self.labelBtn then
				self.labelBtn:setEnabled(value)
				if value then
					self.label:updateStyle(finalParams.style.label.normal)
				else
					self.label:updateStyle(finalParams.style.label.disabled)
				end
			end
		end
	end
	--变更文本
	function radioButton:setText(str)
		if not radioButton.label then

			radioButton.label = THSTG.UI.newLabel({
				text = params.text,
				x = radioButtonSize.width + finalParams.style.labelOffset.x,
				y = radioButtonSize.height / 2 + finalParams.style.labelOffset.y,
				anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
				style = finalParams.style.label.normal,
			})
			radioButton.labelBtn = THSTG.UI.newControlButton({
				x = radioButtonSize.width + finalParams.style.labelOffset.x,
				y = radioButtonSize.height / 2 + finalParams.style.labelOffset.y,
				anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
				curFaceNode = radioButton.label,
				onClick = function (...)
					if not tolua.isnull(params.father) and type(params.index) == "number" then
						params.father:setSelectedButtonIndex(params.index)
					else
						radioButton:setSelected(true)
					end
				end
			})

			function radioButton.labelBtn:setText(str)
				radioButton.label:setText(str)
				radioButton.labelBtn:updateContentSize()
			end
			radioButton:addChild(radioButton.labelBtn)

			radioButton.labelBtn:setEnabled(radioButton:isEnabled())
		end

		radioButton.labelBtn:setText(str)

	end

	--------------------

	if type(params.text) == "string" and params.text ~= "" then
		radioButton:setText(params.text)
	end

	radioButton:setEnabled(finalParams.enabled)

	setHitFactor(radioButton)

	return radioButton
end

--[[
RadioGroup组件
注意：c +  + 中索引值范围：0-(N-1)，lua中调整为1-N
@param	dataProvider		#table			数据源
{
	{x = 0, y = 0, text = ""}, --数据源中每项对应的意义
}
@param	x					#number			x坐标
@param	y					#number			y坐标
@param	enabled				#boolean		是否可用
@param	allowedNoSelection	#boolean		是否允许未选中
@param	selectedButtonIndex	#number			默认选中的按钮索引，(1-N)
@param	onChange			#function		变更选择时的回调
@param	style				#table			每个子对象的样式
]]
function newRadioGroup(params)
	assert(type(params) == "table", "[UI] newRadioButtonGroup() invalid params")

	local finalParams = {
		x = 0, y = 0,
		selectedButtonIndex = 0,
		enabled = true,
		allowedNoSelection = false,
		style = clone(RADIO_BUTTON_DEFAULT_PARAMS.style)
	}
	THSTG.TableUtil.mergeA2B(params, finalParams)
	
	local rbg = ccui.RadioButtonGroup:create()
	rbg:setPosition(finalParams.x, finalParams.y)
	rbg:setAllowedNoSelection(finalParams.allowedNoSelection)

	local function onChange(sender, index, eventType)
		-- print(1, string.format("~~~~~~ sender:%s index:%s eventType:%s", tostring(sender), tostring(index), tostring(eventType)))
		if type(params.onChange) == "function" then
			params.onChange(sender, index + 1, eventType)
		end
	end
	rbg:addEventListener(onChange)

	local function createItem(data, index, father)
		local rb = newRadioButton({
			x = data.x,
			y = data.y,
			text = data.text,
			enabled = finalParams.enabled,
			style = finalParams.style,
			index = index,
			father = father,
		})
		return rb
	end

	for k, v in ipairs(params.dataProvider) do
		local rb = createItem(v, k, rbg)
		rbg:addRadioButton(rb)
		rbg:addChild(rb)
	end

	----------将索引调整至[1-N]----------

	local __setSelectedButton = rbg.setSelectedButton
	local __getSelectedButtonIndex = rbg.getSelectedButtonIndex
	local __setSelectedButtonWithoutEvent = rbg.setSelectedButtonWithoutEvent
	local __getRadioButtonByIndex = rbg.getRadioButtonByIndex


	--value可为number和对应的RadioButton
	function rbg:setSelectedButton(value)
		if type(value) == "number" then
			self:setSelectedButtonIndex(value)
		else
			__setSelectedButton(self, value)
		end
	end

	--增加明确的设置index的方法
	function rbg:setSelectedButtonIndex(value)
		if value > 0 and value <= self:getNumberOfRadioButtons() then
			__setSelectedButton(self, value - 1)
		end
	end

	--为0时表示未选中任何一项
	function rbg:getSelectedButtonIndex()
		return __getSelectedButtonIndex(self) + 1
	end

	function rbg:setSelectedButtonWithoutEvent(value)
		if value > 0 and value <= self:getNumberOfRadioButtons() then
			__setSelectedButtonWithoutEvent(self, value - 1)
		end
	end

	function rbg:getRadioButtonByIndex(index)
		return __getRadioButtonByIndex(self, index - 1)
	end

	------------------------

	if finalParams.selectedButtonIndex > 0 then
		rbg:setSelectedButton(finalParams.selectedButtonIndex)
	end



	return rbg
end








