module(..., package.seeall)
local M = class("LoadingController", Controller)

function M:_onInit()
    THSTG.Dispatcher.addEventListener(EventType.LOADING_EXECUTE, self.__execLoading, self)
end

function M:__execLoading(e,params)
    
end

function M:__execLoading(e,params)

end

return M