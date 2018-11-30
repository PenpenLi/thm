module(..., package.seeall)
local LoadingIcon = require("Scripts.Game.Modules.GUI.MainUi.Component.LoadingIcon")
local M = {}
function M.create(params)
    -------Model-------
    local _uiLoadingIcon = nil
   
    -------View-------
    local node = THSTG.UI.newNode()

    _uiLoadingIcon = LoadingIcon.create()
    node:addChild(_uiLoadingIcon)

    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M