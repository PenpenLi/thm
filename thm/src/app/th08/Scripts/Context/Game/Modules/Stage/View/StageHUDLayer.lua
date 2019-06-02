
local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local _uiStatusLb = false
   
    -------View-------
    local node = THSTG.UI.newNode()

  

    local function init()
     
    end
    init()
    -------Controller-------
   
    node:onNodeEvent("enter", function ()
       
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M