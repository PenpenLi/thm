module(..., package.seeall)
local M = class("PhysicsSystem",THSTG.ECS.System)

function M:_onInit()
    --消息注册
end

function M:_onUpdate(delay)
    local collComps = self:getComponents("RigidbodyComponent")
    for _,v in pairs(collComps) do
    end
end

return M