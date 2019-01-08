module("UTIL", package.seeall)
--TODO:
local M = class("StateMachine")

function M:ctor()
    self._fsm = {}
end

--添加状态
function M:addState(name,froms,to)

end

--设置状态
function M:setState(name)

end

----
function newStateMachine(params)
    return M:create()
end