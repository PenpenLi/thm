
module(..., package.seeall)
local M = class("MenuModule", THSTG.CORE.Module)

function M:_onInit()


    self:addChild(require("Scripts.Context.Game.Modules.Menu.MainMenu.MainMenuModule").new())
end


return M