
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

    local titleLabel = thstg.UI.newLabel({
        text = "Label 的 一XX个测试",
        x = 110,
        y = 30, 
        style = {
            --font = "Arial",
        }
    })
    :addTo(self)

end

return MainScene
