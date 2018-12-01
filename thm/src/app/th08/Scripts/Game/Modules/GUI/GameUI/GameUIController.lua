module(..., package.seeall)
local M = class("GameUIController", Controller)

function M:_onInit()
    self:_initView()
    
end

function M:_initView()
    self.__gameUiLayer = require("Scripts.Game.Modules.GUI.GameUI.GameUiView").create(params)
    LayerManager.add2GUILayer(self.__gameUiLayer)
end

return M