module(..., package.seeall)
local M = class("MenuController", Controller)

function M:_onInit()
    self:_initView()
    
end

function M:_initView()
    self.__menuLayer = require("Scripts.Game.Modules.Menu.MenuView").create(params)
    LayerManager.add2GUILayer(self.__menuLayer)
end

return M