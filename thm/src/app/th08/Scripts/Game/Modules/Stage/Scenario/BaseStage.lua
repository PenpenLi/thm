module(..., package.seeall)
local M = class("BaseStage")

function run()
end

----
--[[由子类进行重载]]
function M:_onMap()

end

function M:_onScenario()

end

return M