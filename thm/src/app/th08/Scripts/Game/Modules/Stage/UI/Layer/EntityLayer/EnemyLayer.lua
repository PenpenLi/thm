module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    -- local _cmpTaskScheduler = THSTG.COMMON.newTaskScheduler()  --任务管理器

    
   
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