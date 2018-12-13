module(..., package.seeall)
local M = class("MainMenuModule", THSTG.CORE.Module)

function M:_onView()
    local layer = require("Scripts.Context.Game.Modules.Menu.MainMenu.Layer.MainMenuLayer").create(params)
    layer:addTo(THSTG.SceneManager.getScene(SceneType.MENU))

    return layer
end

function M:_onInit()

end

return M