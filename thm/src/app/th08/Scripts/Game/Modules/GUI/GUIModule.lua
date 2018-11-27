
local M = class("GameModule", View)
--TODO:这是一个Scene,不应该存在多个Scene
function M:onCreate(params)
    local layer = THSTG.UI.newLayer()
    self:addChild(layer)


    self.__mainUiLayer = require("Scripts.Game.Modules.GUI.MainUi.MainUiLayer").create(params)
    layer:addChild(self.__mainUiLayer)


    self.__gameUiLayer = require("Scripts.Game.Modules.GUI.GameUi.GameUiLayer").create(params)
    layer:addChild(self.__gameUiLayer)

end

return M
