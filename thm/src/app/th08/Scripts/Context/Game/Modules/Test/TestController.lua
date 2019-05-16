module(..., package.seeall)

local M = class("TestController", THSTG.MVC.Controller)

function M:_onInit()
    THSTG.CCDispatcher:addEventListenerWithFixedPriority(THSTG.EVENT.newKeyboardListener({onPressed = function(keyCode, event) self:__keyBoadrControl(keyCode, event) end}), 1)
end

function M:_onOpen()
    
end

function M:_onClose()

end
--

function M:__keyBoadrControl(keyCode, event)
    if keyCode == cc.KeyCode.KEY_F1 then
   
    
    end
end

return M