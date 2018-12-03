module(..., package.seeall)
local M = class("MainMenuView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)
end

function M:_initRealView(params)
    local layer = require("Scripts.Game.Modules.Menu.MainMenu.Layer.MainMenuLayer").create(params)
    return layer
end

return M