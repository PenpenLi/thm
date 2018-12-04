module(..., package.seeall)

local M = class("StageView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)

    self.__gameLayer = false
end

function M:_initRealView(params)
    local layer = cc.Layer:create()

    self.__gameLayer = require("Scripts.Game.Modules.Stage.View.StageGameUI").create()
    layer:addChild(self.__gameLayer)

    

    return layer
end

return M