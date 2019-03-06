

local M = class("RigidbodyComponent",ECS.Component)

function M:_onInit()
    self.mass = 1
    self.speed = cc.p(0,0)
    self.gravityScale = 1.0

    self.retForce = cc.p(0,0)  --合力

    self._isGravityEnabled = true

    self._physicsBody = THSTG.PHYSICS.newBox()--理论质点

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
    if type(x) == "table" and not y then
        self.speed = x
        return 
    end
    self.speed = cc.p(x,y)
end

function M:setMass(val)
    val = val or self.mass
    self.mass = math.max(1,val)
end

function M:setGravityEnabled(val)
    self._isGravityEnabled = val
    self._physicsBody:setGravityEnable(val)
end

function M:isGravityEnabled()
    return self._isGravityEnabled
end

-----
function M:setBody(body)
    local scene = self:getEntity():getScene()
    if scene and scene:getPhysicsWorld() then
        self:getEntity():setPhysicsBody(body)
    end
end

function M:getBody()
    return self:getEntity():getPhysicsBody()
end
-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))

end

function M:_onEnter()
    M.super._onEnter(self)

    local scene = self:getEntity():getScene()
    if scene and scene:getPhysicsWorld() then
        self:getEntity():setPhysicsBody(self._physicsBody)
        self:setGravityEnabled(self:isGravityEnabled())
    end
end

function M:_onRemoved(entity)
    
end


return M