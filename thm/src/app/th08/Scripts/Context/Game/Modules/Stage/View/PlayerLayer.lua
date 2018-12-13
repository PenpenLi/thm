module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _Reimu = StageDefine.Reimu:create()

    
   
    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_Reimu)

    

  
    -------Controller-------

    node:onNodeEvent("enter", function ()
       
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M