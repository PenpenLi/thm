local M = class("SceneView", View)

function M:onCreate()
    local mainLayer = require ("Modules.Scene.MainUi.Layer.MenuLayer").create()
    self:addChild(mainLayer)
end

return M