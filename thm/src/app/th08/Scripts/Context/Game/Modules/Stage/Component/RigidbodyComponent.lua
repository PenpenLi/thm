
---
local Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")
local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.mass = 1
    self.speed = cc.p(0,0)
    self.gravityScale = 1.0

    self._transComp = nil
    self._force = cc.p(0,0)
    self._acceSpeed = cc.p(0,0)
end

--力和施力位置
function M:addForce(power,pos)
    --TODO:pos,非中心力产生力作用不同
    self._force = power
    self._acceSpeed.x = power.x / self.mass
    self._acceSpeed.y = power.y / self.mass
end
-----
function M:setSpeed(x,y)
    self.speed = cc.p(x,y)
end
-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))
end

function M:_onRemoved(entity)

end

function M:_onUpdate()
    --加速度叠加
    self.speed.x = self.speed.x + self._acceSpeed.x
    self.speed.y = self.speed.y + self._acceSpeed.y

    --计算位移
    self._transComp:setPositionX(self._transComp:getPositionX() + self.speed.x)
    self._transComp:setPositionY(self._transComp:getPositionY() + self.speed.y)
end

function M:_onLateUpdate()
    -- 非持续力,每帧清空
    self._force = cc.p(0,0)
end


return M