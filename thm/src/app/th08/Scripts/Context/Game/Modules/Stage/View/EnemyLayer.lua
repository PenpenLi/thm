module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _cTaskScheduler = THSTG.UTIL.newTaskScheduler()  --任务管理器

    
   
    -------View-------
    local node = THSTG.UI.newNode()


    

  
    -------Controller-------
    local function updateFrame()
        _cTaskScheduler:poll()
    end
 

    node:onNodeEvent("enter", function ()
        node:scheduleUpdateWithPriorityLua(updateFrame,0)
       
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)
    
    return node
end

return M