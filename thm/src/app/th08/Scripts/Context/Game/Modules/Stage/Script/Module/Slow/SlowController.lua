local M = class("SlowController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.__isStateSlow = nil
end

-------
-------

function M:slow(state)
    --根据不同人物显示不同的低速模式
    if self.__isStateSlow == state then return end
    if state then 
        self:_slowOpen() 
    else 
        if not self.__isStateSlow then return end
        self:_slowClose() 
    end
end

function M:isSlow()
    return self.__isStateSlow or false
end

function M:_slowOpen()
    --切换到 妖模式
    print(15,"slow开")
    self:_onSlowOpen()
    self.__isStateSlow = true
end

function M:_slowClose()
    --切换到 人模式
    print(15,"slow关")
    self:_onSlowClose()
    self.__isStateSlow = false
end
-----
function M:_onSlowOpen()
end

function M:_onSlowClose()
end
-----
function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M