local M = class("SlowController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.__isStateSlow = nil
end

-------
-------

function M:slow(state)
    --根据不同人物显示不同的低速模式
    if state then self:_slowOpen() else self:_slowClose() end
end

function M:isSlow()
    return self.__isStateSlow or false
end

function M:_slowOpen()
    --切换到 妖模式
    print(15,"slow开")
    self.__isStateSlow = true
end

function M:_slowClose()
    --切换到 人模式
    print(15,"slow关")
    self.__isStateSlow = false
end
-----
function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M