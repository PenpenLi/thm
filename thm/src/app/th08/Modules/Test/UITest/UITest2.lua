module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
   

    --------View--------
    local node = THSTG.UI.newNode()

    

    --------Controller--------
  
    node:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithFixedPriority(_varKeyboardListener, 1)
	end)

	node:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
    end)

    return node
end
return M