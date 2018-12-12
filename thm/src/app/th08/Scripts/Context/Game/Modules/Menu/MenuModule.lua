
module(..., package.seeall)
local M = class("MenuModule", THSTG.CORE.Module)

function M:_onInit()

    self:addChild(require("Scripts.Context.Game.Modules.Menu.MainMenu.MainMenuModule").new(),"MainMenuModule")
end

function M:_onView()
    self:setViewParent(THSTG.SceneManager.getScene(SceneType.MENU))
    
    local layer = require("Scripts.Context.Game.Modules.Menu.MainMenu.Layer.MainMenuLayer").create(params)
    return layer
end

return M