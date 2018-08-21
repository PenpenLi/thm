module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

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
        style = {
            skin = {
                bgNormal = "Assets/UI/RadioButton/bg_normal.png",
                bgDisabled = "Assets/UI/RadioButton/bg_disabled.png",
                cross = "Assets/UI/RadioButton/radio_btn_sel1.png",
                crossDisabled = "Assets/UI/RadioButton/radio_btn_sel_disa1.png",
            }
        },
        onChange = function (sender, selectedIndex, eventType)
            print(15,"XXXXXX")
        end,
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
    
    return layer
end
return M