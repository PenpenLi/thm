module(..., package.seeall)
local StartMenu = require("Scripts.Game.Modules.GUI.GameUi.StartMenu.MainMenuLayer")
local M = {}
function M.create(params)
    -------Model-------
    local _menuLayer = nil
   
    -------View-------
    local node = THSTG.UI.newNode()

    --菜单
    _menuLayer = StartMenu.create(params)
    node:addChild(_menuLayer)

    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M