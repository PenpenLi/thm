module(..., package.seeall)

local M = class("TestModule", View)

function M:onCreate()
    -- add background image
    THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "HelloWorld.png"
    })
    :addTo(self)

    -- add HelloWorld label
    THSTG.UI.newLabel({
        x = display.cx,
        y = display.cy+200,
        text = "Hello World",
        anchorPoint = THSTG.UI.POINT_CENTER,
        style = {
            font = "Arial",
            size = 40,
        }
    })
    :addTo(self)

    local titleLabel = THSTG.UI.newLabel({
        text = "Label 的 一XX个测试",
        x = 110,
        y = 30, 
   
        style = {
            --font = "Arial",
        }
    })
    :addTo(self)

    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        src = "res/th08/title01.png",
        frame = {x= 0,y = 0,width =100,height=100},
    })
    :addTo(self)


    local btn = THSTG.UI.newButton({
		text = "btn_AA",
		x = 50,
		y = display.cy,
		width = 100, --height=40,
		anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		-- zoomScale=0.6,
		style = {
			normal = {
				label = {size = THSTG.UI.FONT_SIZE_NORMAL, color = UI.COLOR_RED, outline = 1},
				skin = {src = "res/th08/close.png"}
			},
			selected = {
				label = {size = 12, color = THSTG.UI.COLOR_YELLOW, outline = 2, outlineColor = THSTG.UI.COLOR_BLUE},
				skin = {src = "res/th08/open.png"}
			},
			disabled = {
				label = {size = THSTG.UI.FONT_SIZE_BIGGEST, color = THSTG.UI.COLOR_GRAY_C, outline = 3},
				skin = {src = "res/th08/open.png"}
			}
		},
	})
	:addTo(self)
    --一个Window

    --一个LayerStack

    --一个TabBar
end

return M