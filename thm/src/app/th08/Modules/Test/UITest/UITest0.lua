module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()
  
    -- add background image
    display.newSprite("HelloWorld.png")
    :move(display.center)
    :addTo(layer)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(layer)

    return layer
end
return M