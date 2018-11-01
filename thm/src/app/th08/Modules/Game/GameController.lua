module(..., package.seeall)
local M = class("GameController", Controller)

function M:_onInit()

    THSTG.Dispatcher.addEventListener(EventType.GAME_TEST_PRINT,self.__testEvent,self)

end

function M:__testEvent(e,params)
    print(0,"TestEvent:",params)
end

return M