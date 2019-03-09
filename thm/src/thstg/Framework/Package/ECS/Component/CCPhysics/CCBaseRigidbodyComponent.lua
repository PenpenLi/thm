

--[[
    --TODO:
    基于chipmunk
    physicsBody:setCollisionBitmask(self:getID())
    physicsBody:setCategoryBitmask(self:getID()+1)
    physicsBody:setContactTestBitmask(self:getID()+1)
]]
local M = class("CCBaseRigidbodyComponent",ECS.Component)

function M:_onInit()
  
    self._physicsBody = THSTG.PHYSICS.newBox()--理论质点
    self._transComp = nil
end

--力
function M:applyForce(force,offset)
    self._physicsBody:applyForce(force,offset)
end
--冲量
function M:applyImpulse(impulse,offset)
    self._physicsBody:applyImpulse(impulse,offset)
end
-----
function M:setVelocity(velocity)
    self._physicsBody:setVelocity(velocity)
end

function M:setMass(val)
    val = val or self.mass
    self.mass = math.max(1,val)
end

function M:setGravityEnabled(val)
    self._physicsBody:setGravityEnable(val)
end

function M:isGravityEnabled()
    return self._physicsBody:isGravityEnabled()
end


function M:getPhysicsBody()
    return self:getEntity():getPhysicsBody()
end
----

function M:setSensor(val)
    local mask = val and 0xFFFFFFFF or 0x0
    self._physicsBody:setCollisionBitmask(mask)
end

function M:isSensor(val)
    local mask = self._physicsBody:getCollisionBitmask()
    return (mask == 0x0)
end

-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))
end

function M:_onEnter()
    M.super._onEnter(self)
    if self:_isCCPhysicsWorld() then
        self:setPhysicsBody(self._physicsBody)
    end
end

function M:_onExit()
    
end

function M:_isCCPhysicsWorld()
    local isAdded = self:isAdded()
    if isAdded then
        local scene = self:getEntity():getScene()
        if isAdded and scene and scene:getPhysicsWorld() then
            return true
        end
    end
    return false
end

-----
function M:_setPhysicsBody(body)
    self:getEntity():setPhysicsBody(body)
end


return M