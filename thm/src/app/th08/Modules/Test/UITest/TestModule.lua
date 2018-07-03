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

    --一个Window

    --一个LayerStack

    --一个TabBar
end

return M