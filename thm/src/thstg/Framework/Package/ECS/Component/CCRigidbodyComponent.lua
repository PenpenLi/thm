

--[[
    --TODO:
    基于chipmunk
    physicsBody:setCollisionBitmask(self:getID())
    physicsBody:setCategoryBitmask(self:getID()+1)
    physicsBody:setContactTestBitmask(self:getID()+1)
]]
local M = class("RigidbodyComponent",ECS.Component)

function M:_onInit()
  
    self._physicsBody = THSTG.PHYSICS.newBox()--理论质点
    self._transComp = nil
end

--力和施力位置
function M:addForce(power,pos)
  
end
-----
function M:setSpeed(x,y)
    if type(x) == "table" and not y then
        self.speed = x
        return 
    end

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

-----
function M:setPhysicsBody(body)
    self:getEntity():setPhysicsBody(body)
end

function M:getPhysicsBody()
    return self:getEntity():getPhysicsBody()
end
-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))
end

function M:_onEnter()
    M.super._onEnter(self)
    self:setPhysicsBody(self._physicsBody)

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

return M