module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

	local function onChange1(sender, selectedIndex, eventType)
        -- dump(sender, selectedIndex, eventType)
        print(15,selectedIndex)
	end

	local rbg1 = THSTG.UI.newRadioGroup({
		dataProvider = {
			{x = 0, y = 300, text = "aa"},
			{x = 50, y = 250, text = "bb"},
			{x = 0, y = 200, text = "cc"},
			{x = 50, y = 150, text = "dd"},
			{x = 0, y = 100, text = "ee"},
		},
		x = 200, y = 160,
		enabled = false,
        allowedNoSelection = true,
        selectedButtonIndex = 1,
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
        onChange = onChange1,
	})
    layer:addChild(rbg1)


    local rbg2 = THSTG.UI.newRadioGroup({
		dataProvider = {
			{x = 50, y = 100, text = "aa"},
			{x = 100, y = 100, text = "bb"},
			{x = 150, y = 100, text = "cc"},
			{x = 200, y = 100, text = "dd"},
			{x = 250, y = 100, text = "ee"},
		},
        x = 200, y = 100,
        selectedButtonIndex = 1,
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
        onChange = function (sender, selectedIndex, eventType)
            rbg1:setSelectedButtonIndex(selectedIndex)
        end,
	})
    layer:addChild(rbg2)
    

    local rb1 = THSTG.UI.newRadioButton({
        x = 150+display.cx - 20, y = 100, 
        -- onChange = onChange, 
        enabled = true, 
        selected = false, 
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
    })
    layer:addChild(rb1)

    local rb2 = THSTG.UI.newRadioButton({
        x = 150+display.cx + 20, y = 100, 
        -- onChange = onChange, 
        enabled = false, 
        selected = true, 
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
    })
    layer:addChild(rb2)

    local rb3 = THSTG.UI.newRadioButton({
        x = 150+display.cx - 60, y = 100, 
        -- onChange = onChange, 
        enabled = true, 
        selected = true, 
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
    })
    layer:addChild(rb3)

    local rb4 = THSTG.UI.newRadioButton({
        x = 150+display.cx + 60, y = 100, 
        -- onChange = onChange, 
        enabled = false, 
        selected = false, 
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
    })
    layer:addChild(rb4)

    --
    --CheckBox\
    local cb1 = THSTG.UI.newCheckBox({
		text = "我是带文本的CheckBox",
		x = 100,
        y = 40,
        anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		onChange = onChange,
		selected = true, --是否选中
		enabled = false, --是否可用
		style = {
            skin = {
                bgNormal = "Assets/UI/CheckBox/check_box_bg1.png",
                cross = "Assets/UI/CheckBox/check_box_sel1.png",
                bgDisabled = "Assets/UI/CheckBox/check_box_bg1.png",
                crossDisabled = "Assets/UI/CheckBox/check_box_dis1.png",
            },
			label = {
				normal = {size = THSTG.UI.FONT_SIZE_BIGGEST, color = THSTG.UI.COLOR_YELLOW},
				disabled = {size = THSTG.UI.FONT_SIZE_BIGGEST}
			},
			labelOffset = {x = 10, y = 0}
		}
	})
	layer:addChild(cb1)

	local function onChange2(sender, isSelected)
		printf("~~~222~~~ sender:%s isSelected:%s", tostring(sender), tostring(isSelected))
		cb1:setSelected(isSelected)
	end

	local cb2 = THSTG.UI.newCheckBox({
		text="cb1是否被选中",
		x = 100,
		y = 80,
		onChange = onChange2,
        selected = true,
        anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		style = {
            skin = {
                bgNormal = "Assets/UI/CheckBox/check_box_bg1.png",
                cross = "Assets/UI/CheckBox/check_box_sel1.png",
                bgDisabled = "Assets/UI/CheckBox/check_box_bg1.png",
                crossDisabled = "Assets/UI/CheckBox/check_box_dis1.png",
            },
			label={
				normal={ size=35,color=THSTG.UI.COLOR_BLUE},
				disabled={ size=35, color=THSTG.UI.COLOR_YELLOW }
			},
			labelOffset={ x=10, y=0}
		}
	})
	layer:addChild(cb2)

	local function onChange3(sender, isSelected)
		printf("~~~333~~~ sender:%s isSelected:%s", tostring(sender), tostring(isSelected))
		local x,y=cb2:getPosition()
		print("cb2 pos:",x,y)
		cb1:setEnabled(isSelected)
	end

	local cb3 = THSTG.UI.newCheckBox({
		text="cb1是否可用",
		x = 100,
		y = 120,
		onChange = onChange3,
		anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		style = {
            skin = {
                bgNormal = "Assets/UI/CheckBox/check_box_bg1.png",
                cross = "Assets/UI/CheckBox/check_box_sel1.png",
                bgDisabled = "Assets/UI/CheckBox/check_box_bg1.png",
                crossDisabled = "Assets/UI/CheckBox/check_box_dis1.png",
            },
			label={
				normal={ size=35,color=THSTG.UI.COLOR_BLUE},
				disabled={ size=35,color=THSTG.UI.COLOR_YELLOW }
			},
			labelOffset={x=10,y=0}
		}
	})
	layer:addChild(cb3)

	local function onChange4(sender,isEnabled)
		-- body
		print("checkBoxTest 测试是否可用！")
		local x,y=cb3:getPosition()
		print("cb3 Position:",x,y)
		cb2:setEnabled(isEnabled)
		cb3:setEnabled(isEnabled)
	end

	local checkBoxTest=THSTG.UI.newCheckBox(
	{
		text = "checkBoxTest",
		x = 100,
		y = 160,
		onChange=onChange4,
		anchorPoint=THSTG.UI.POINT_LEFT_BOTTOM,
		style = {
            skin = {
                bgNormal = "Assets/UI/CheckBox/check_box_bg1.png",
                cross = "Assets/UI/CheckBox/check_box_sel1.png",
                bgDisabled = "Assets/UI/CheckBox/check_box_bg1.png",
                crossDisabled = "Assets/UI/CheckBox/check_box_dis1.png",
            },
			label={
				normal={ size=40,color=THSTG.UI.COLOR_GREEN},
				disabled={ size=40 }
			},
			labelOffset={ x=10,y=0 }
		}
	})
	layer:addChild(checkBoxTest)


    return layer
end
return M