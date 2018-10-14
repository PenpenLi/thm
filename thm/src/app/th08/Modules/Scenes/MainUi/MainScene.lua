local M = class("MainScene", View)

function M:onCreate()
    local mainLayer = require ("Modules.Scenes.MainUi.Layer.MenuLayer").create()
    self:addChild(mainLayer)
end

return M