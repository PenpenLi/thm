local M = class("KeyboardControl",cc.Node)

local function updateFrame()
    
end

function M:ctor()
    self._varKeyboardListener = false


    self:onNodeEvent("enter", function ()
        M:scheduleUpdateWithPriorityLua(updateFrame,0)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, M)
    end)

    self:onNodeEvent("exit", function ()
        M:unscheduleUpdate()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
       
    end)
end




return M