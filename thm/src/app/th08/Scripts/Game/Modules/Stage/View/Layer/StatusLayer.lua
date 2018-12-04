module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _uiBooldBar = require("Scripts.Game.Modules.Stage.View.Component.BloodBar").create()

   
    -------View-------
    local node = THSTG.UI.newNode()

  
    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M