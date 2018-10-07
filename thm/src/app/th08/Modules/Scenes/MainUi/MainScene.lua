local M = class("StartScene", View)

function M:onCreate()
    -- -- add background image
    -- display.newSprite("HelloWorld.png")
    -- :move(display.center)
    -- :addTo(self)

    -- -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)
    local mainBg = THSTG.UI.newImage({
        x = 0,
        y = 0,
        src = ResManager.getRes()

    })

end

return M