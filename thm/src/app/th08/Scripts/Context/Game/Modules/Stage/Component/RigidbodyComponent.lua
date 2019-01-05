
---
local Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")
local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.mass = 1
    -- self.speed = Speed.new()
    self.speed = cc.p(0,0)
    self.gravityScale = 1.0
end

--力和施力位置
function M:addForce(power,pos)
    
end
----
function M:_onAdded()
    local transComp = entity:getComponent("TransformComponent")
    assert(transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))
end

function M:_onRemoved()

end

function M:_onUpdate()
    local transComp = self:getComponent("TransformComponent")
    transComp:setPositionX(transComp:getPositionX() + self.speed.x)
    transComp:setPositionY(transComp:getPositionY() + self.speed.y)
end


return M