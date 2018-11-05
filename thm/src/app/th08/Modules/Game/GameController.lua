module(..., package.seeall)
local M = class("GameController", Controller)

function M:_onInit()

    THSTG.Dispatcher.addEventListener(EventType.GAME_TEST_PRINT,self.__testEvent,self)
    THSTG.Dispatcher.addEventListener(EventType.GAME_SHOW_LOADING_SCENE,self.__showLoaningScene,self)
end

function M:__testEvent(e,params)
    print(0,"TestEvent:",params)
end

function M:__showLoaningScene(e,params)
    --[[
        params:
        @callback   [function]      回调函数
            
    ]]
    --场景切换
end

return M