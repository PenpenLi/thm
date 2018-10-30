local M = class("MainScene", View)

function M:onCreate()

    local layer = require ("Modules.Scene.MainUi.Layer.MenuLayer").create()
    self:addChild(layer)
    
end

return M