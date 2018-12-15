module(..., package.seeall)

function isCollision(entityA,entityB)
    local RigidBodyA = entityA:getComponent("RigidbodyComponent")
    local RigidBodyB = entityB:getComponent("RigidbodyComponent")

    if RigidBodyA and RigidBodyB then
        

    end
end