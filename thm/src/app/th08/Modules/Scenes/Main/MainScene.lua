
local MainScene = class("MainScene", View)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
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
        x = 0,
        y = 0,
        src = "res/th08/title01.png",
        rect = {left=0,top=0,right=100,bottom=100}
    })
    :addTo(self)

end

return MainScene
