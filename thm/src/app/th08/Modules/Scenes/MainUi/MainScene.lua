local M = class("MainScene", View)

function M:onCreate()
    local mainLayer = require ("Modules.Scenes.MainUi.Layer.SelectDifficultyLayer").create()
    self:addChild(mainLayer)
end

return M