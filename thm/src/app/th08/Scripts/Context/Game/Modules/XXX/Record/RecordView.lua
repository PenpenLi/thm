module(..., package.seeall)
local M = class("MainMenuView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)
end

function M:_initRealView(params)
    return nil
end

return M