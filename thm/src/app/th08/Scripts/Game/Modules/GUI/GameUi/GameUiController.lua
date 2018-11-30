module(..., package.seeall)
local M = class("GameUiController", Controller)

function M:_onInit()
    self:_initView()
    
end

function M:_initView()
    self.__gameUiLayer = require("Scripts.Game.Modules.GUI.GameUi.GameUiView").create(params)
    LayerManager.add2GUILayer(self.__gameUiLayer)
end

return M