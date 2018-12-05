module(..., package.seeall)

local M = class("StageView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)

    --游戏场景
    self.__gameLayer = false
    --结算场景
    self.__resultLayer = false
    --退出场景
    self.__exitLayer = false
end

function M:_initRealView(params)
    local layer = cc.Layer:create()

    self.__gameLayer = require("Scripts.Game.Modules.Stage.UI.StageGameUI").create()
    layer:addChild(self.__gameLayer)

    

    return layer
end

return M