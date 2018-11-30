module(..., package.seeall)
local M = class("GameController", Controller)

function M:_onInit()
    self:_initView()
    
end

function M:_initView()
    self.__gameUiLayer = require("Scripts.Game.Modules.GUI.GameUi.GameUiLayer").create(params)
    LayerManager.add2GUILayer(self.__gameUiLayer)
end

return M