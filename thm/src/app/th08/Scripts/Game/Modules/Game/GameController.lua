module(..., package.seeall)
local M = class("GameController", Controller)

function M:_onInit()
    THSTG.Dispatcher.addEventListener(EventType.GAME_TEST_PRINT,self.__testEvent,self)
    THSTG.Dispatcher.addEventListener(EventType.GAME_REPLACE_SCENE,self.__replaceScene,self)
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

return M