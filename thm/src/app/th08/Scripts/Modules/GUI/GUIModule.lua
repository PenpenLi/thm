
local M = class("GameModule", View)
--TODO:这是一个Scene,不应该存在多个Scene
function M:onCreate(params)


    --菜单
    self.__menuLayer = require("Scripts.Modules.GUI.GameUi.StartMenu.MainMenuLayer").create(params)
    self:addChild(self.__menuLayer)

    -- --loading
    -- self.__loadingLayer = require("Scripts.Modules.GUI.PublicUi.LoadingLayer").create(params)
    -- self:addChild(self.__loadingLayer)


end

return M
