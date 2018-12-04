module(..., package.seeall)
local M = class("BaseStage")
function M:ctor()
    self:_onInit()
end

function M:run()
    if self:_onLoad() then

    end
end

----

--[[由子类进行重载]]
function M:_onInit()

end

function M:_onLoad()

    return true
end

function M:_onMap()

end

function M:_onScenario()

end

return M