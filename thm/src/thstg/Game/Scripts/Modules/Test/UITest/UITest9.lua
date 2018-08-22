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
        x = display.cx - 20, y = 100, 
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
        x = display.cx + 20, y = 100, 
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
        x = display.cx - 60, y = 100, 
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
        x = display.cx + 60, y = 100, 
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

    return layer
end
return M