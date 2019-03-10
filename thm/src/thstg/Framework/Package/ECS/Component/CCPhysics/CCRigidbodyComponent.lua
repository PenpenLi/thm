

--[[
    基于chipmunk
]]
local CCPhysicsUtil = require("thstg.Framework.Package.ECS.Component.CCPhysics.CCPhysicsUtil")
local M = class("CCRigidbodyComponent",ECS.Component)

function M:_onInit()
    self._physicsBody = THSTG.PHYSICS.newBox()--理论质点
    self._transComp = nil
end

--力
function M:applyForce(force,offset)
    offset = offset or cc.p(0,0)
    self:_getPhysicsBody():applyForce(force,offset)

end
--冲量
function M:applyImpulse(impulse,offset)
    offset = offset or cc.p(0,0)
    self:_getPhysicsBody():applyImpulse(force,offset)
end
-----
function M:setVelocity(velocity)
    self:_getPhysicsBody():setVelocity(velocity)
end
function M:getVelocity()
    self:_getPhysicsBody():getVelocity()
end

function M:setGravityEnable(val)
    self:_getPhysicsBody():setGravityEnable(val)
end

function M:isGravityEnabled()
    return self:_getPhysicsBody():isGravityEnabled()
end

-----
function M:_onAdded(entity)
    self._transComp = entity:getComponent("TransformComponent")
    assert(self._transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))

    self._physicsBody = self._physicsBody or THSTG.PHYSICS.newBox()
    self._physicsBody:retain()
end

function M:_onRemove(entity)
    local colliderComp = self:getComponent("CCBaseColliderComponent")
    if not colliderComp then
        self:_setPhysicsBody(nil)
    end
end

-- function M:_onEnter()
--     M.super._onEnter(self)
--     if CCPhysicsUtil.isCCPhysicsWorld(self) then
--         if not self:getEntity():getPhysicsBody() then
--             if not self._physicsBody then 
--                 self._physicsBody = THSTG.PHYSICS.newBox()
--                 self._physicsBody:retain()
--             end
--             self:_setPhysicsBody(self._physicsBody)
--             self:_initComp()

--             self._physicsBody:release()
--             self._physicsBody = nil
--         end
--     end
-- end


function M:_onEnter()
    M.super._onEnter(self)
    if CCPhysicsUtil.isCCPhysicsWorld(self) then
        local colliderComp = self:getComponent("CCBaseColliderComponent")
        if not colliderComp then
            self:_setPhysicsBody(self._physicsBody)
            self:_initComp()
        else
            CCPhysicsUtil.copyPhysicsBodyProps(self:_getPhysicsBody(),colliderComp:_getPhysicsBody())
        end
        self._physicsBody:release()
        self._physicsBody = nil
    end
end


-----
function M:_getPhysicsBody()
    return self._physicsBody or self:getEntity():getPhysicsBody()
end

function M:_setPhysicsBody(body)
    self:getEntity():setPhysicsBody(body)
end

function M:_initComp()
    --忽略一切碰撞
    self:_getPhysicsBody():setCollisionBitmask(0x0)
end

return M