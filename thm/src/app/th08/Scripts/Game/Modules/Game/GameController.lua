module(..., package.seeall)
local M = class("GameController", Controller)

function M:ctor()
    self._module = false
    self.super.ctor(self)
end

function M:_onInit()

    THSTG.Dispatcher.addEventListener(EventType.GAME_TEST_PRINT,self.__testEvent,self)
    THSTG.Dispatcher.addEventListener(EventType.GAME_REPLACE_SCENE,self.__replaceScene,self)
    THSTG.CCDispatcher:addEventListenerWithFixedPriority(THSTG.EVENT.newKeyboardListener({onPressed = function(keyCode, event) self:__keyBoadrControl(keyCode, event) end}), 1)
end

function M:__testEvent(e,params)
    print(0,"TestEvent:",params)
end

function M:__replaceScene(e,params)
    --[[
        params:
        @type       [string]            场景类型
        @transition  [userdate]          场景动画
        @callback   [function]          回调函数
        @params     [table]              附加参数
            
    ]]
    --场景切换
    if params.type then
        local scene = nil
        if params.type == SceneType.MAIN_SCENE then
            scene = require("Scripts.Game.Modules.Game.Scene.MainScene"):create(params.params) 
        elseif params.type == SceneType.GAME_SCENE then
            scene = require("Scripts.Game.Modules.Game.Scene.GameScene"):create(params.params) 

        end
        display.runScene(scene)
    end
end

function M:__keyBoadrControl(keyCode, event)
    if keyCode == cc.KeyCode.KEY_F1 then
        if not self._module then
            self._module = require("Scripts.Game.Modules.Test.TestModule"):create() 
            self._module:showWithScene()
        else
            --切换回原场景
            self._module = false
            require("Scripts.Game.Modules.GUI.GUIModule"):create():showWithScene()  
        end
    end
end

return M