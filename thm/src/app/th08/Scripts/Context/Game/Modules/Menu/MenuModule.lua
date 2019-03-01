
module(..., package.seeall)
local M = class("MenuModule", THSTG.MVC.Module)

function M:_onInit()
    self:addChild(require("Scripts.Context.Game.Modules.Menu.MainMenu.MainMenuModule").new())
end

function M:_onView()
    --主菜单无界面
end


return M