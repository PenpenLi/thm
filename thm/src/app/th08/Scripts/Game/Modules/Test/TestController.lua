module(..., package.seeall)
local M = class("TestController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Test.TestView"
end

function M:_onInit()
    THSTG.CCDispatcher:addEventListenerWithFixedPriority(THSTG.EVENT.newKeyboardListener({onPressed = function(keyCode, event) self:__keyBoadrControl(keyCode, event) end}), 1)
end

function M:__keyBoadrControl(keyCode, event)
    if keyCode == cc.KeyCode.KEY_F1 then
        ModuleManager.enterTestScene()
    elseif keyCode == cc.KeyCode.KEY_F2 then
        ModuleManager.enterMenuScene()
    elseif keyCode == cc.KeyCode.KEY_F3 then
        ModuleManager.enterStageScene()
    end
end

return M