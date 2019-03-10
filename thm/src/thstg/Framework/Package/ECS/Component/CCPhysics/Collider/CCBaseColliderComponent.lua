

local CCPhysicsUtil = require("thstg.Framework.Package.ECS.Component.CCPhysics.CCPhysicsUtil")
--[[
    physicsBody:setCollisionBitmask(self:getID())
    physicsBody:setCategoryBitmask(self:getID()+1)
    physicsBody:setContactTestBitmask(self:getID()+1)
]]
local M = class("CCBaseColliderComponent",ECS.Component)

function M:ctor(params)
    M.super.ctor(self)
end

function M:_onInit()
    self._physicsBody = nil
    self._rigidBody = nil

end
-------

function M:setSensor(val)
    local mask = val and 0x0 or 0xFFFFFFFF
    self:_getPhysicsBody():setCollisionBitmask(mask)
end

function M:isSensor(val)
    local mask = self:_getPhysicsBody():getCollisionBitmask()
    return (mask == 0x0)
end
-------
function M:setGroup(group)
    self:_getPhysicsBody():setGroup(group)
end

function M:getGroup()
    return self:_getPhysicsBody():getGroup()
end

-------
function M:_onAdded(entity)
    self._rigidBody = entity:getComponent("CCRigidbodyComponent")
    
end

function M:_onRemove(entity)
    local rigidBodyComp = self:getComponent("CCRigidbodyComponent")
    if not rigidBodyComp then
        self:_setPhysicsBody(nil)
    end
end

function M:_onEnter()
    M.super._onEnter(self)
    if CCPhysicsUtil.isCCPhysicsWorld(self) then
        if self._physicsBody then
            self:_setPhysicsBody(self._physicsBody)
            self._physicsBody:release()
            self._physicsBody = nil
        end
        self:_initComp()
    end
end

--
function M:_getPhysicsBody()
    return self._physicsBody or self:getEntity():getPhysicsBody()
end

function M:_setPhysicsBody(body)
    self:getEntity():setPhysicsBody(body)
end

function M:_initComp()

end

return M