module(..., package.seeall)
local M = class("MainMenuView", View)

function M:ctor(params)
    self.super.ctor(self)
    self:setLayer(LayerManager.guiLayer)
end

function M:_initRealView(params)
    local layer = require("Scripts.Game.Modules.Selection.Layer.SelectionLayer").create(params)
    return layer
end

return M