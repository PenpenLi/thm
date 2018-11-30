module(..., package.seeall)
local M = class("TestController", Controller)
function M:ctor()
    self._module = false
    self.super.ctor(self)
end
function M:_onInit()
    THSTG.CCDispatcher:addEventListenerWithFixedPriority(THSTG.EVENT.newKeyboardListener({onPressed = function(keyCode, event) self:__keyBoadrControl(keyCode, event) end}), 1)
end

function M:__keyBoadrControl(keyCode, event)
    if keyCode == cc.KeyCode.KEY_F1 then
        if not self._module then
            --TODO:
            self._module = require("Scripts.Game.Modules.Test.TestModule"):create() 
            self._module:showWithScene()
        else
            --切换回原场景
            self._module = false
            local scene = require("Scripts.Game.Modules.GUI.GUIModule"):create()
            scene:showWithScene()  
        end
    end
end

return M