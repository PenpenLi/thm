module(..., package.seeall)
local M = class("MainUIView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)
end

function M:_initRealView(params)
    return cc.Layer:create()
end

return M