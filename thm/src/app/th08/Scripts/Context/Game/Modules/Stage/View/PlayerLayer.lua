module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _ePlayer = StageDefine.Player.new()


    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_ePlayer)
    
    -------Controller-------
  


    node:onNodeEvent("enter", function ()
   
    end)

    node:onNodeEvent("exit", function ()
  
    end)
    
    return node
end

return M