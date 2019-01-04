module(..., package.seeall)
local M = class("InputSystem",THSTG.ECS.System)

function M:_onInit()
    self._keyMapper = THSTG.UTIL.newControlMapper()
    self._keyboardListener = THSTG.EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
         
        end,

        onReleased = function(keyCode, event)
           
        end,
    })

    self._touchListener = THSTG.EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
           
            return true
        end,
        onMoved = function(touches, event)
            
        end,
        onEnded = function(touches, event)
           
        end,
        onDoubleClick = function(touches, event)
            
        end,
        onShaked = function(touches, event)
            
        end,
    })
end

function M:_onUpdate(delay)
   
end

return M