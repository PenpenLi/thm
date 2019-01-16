
---
local Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")
local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.mass = 1
    self.speed = cc.p(0,0)
    self.gravityScale = 1.0
    self.retForce = cc.p(0,0)  --合力

    self._transComp = nil

end

--力和施力位置
function M:addForce(power,pos)
    --XXX:pos,非中心力产生力作用不同,要区分质点与非质点
    -- pos = pos or cc.p(0.5,0.5)--中心
    self.retForce.x = self.retForce.x + power.x
    self.retForce.y = self.retForce.y + power.y
end
-----
function M:setSpeed(x,y)
    self.speed = cc.p(x,y)
end

function M:setMass(val)
    val = val or self.mass
    self.mass = math.max(1,val)
end
-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))
end

function M:_onRemoved(entity)
    
end


return M