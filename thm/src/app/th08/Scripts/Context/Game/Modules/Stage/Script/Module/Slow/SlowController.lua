local M = class("SlowController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.__isStateSlow = nil
end

-------
-------
function M:slow(state)
    local function slowOpen()
        print(15,"slow开")
       
    end
    local function slowClose()
        print(15,"slow关")
       
    end
    --根据不同人物显示不同的低速模式
    if state then slowOpen() else slowClose() end
    self.__isStateSlow = state
end

function M:isSlow()
    return self.__isStateSlow or false
end

function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M