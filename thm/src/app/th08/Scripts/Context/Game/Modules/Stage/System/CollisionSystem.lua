module(..., package.seeall)

--自己与所有实体做碰撞检测
function isCollision(player,entity)
    local RigidBodyPlayer = player:getComponent("RigidbodyComponent")
    local RigidBodyEntity = entity:getComponent("RigidbodyComponent")

    if RigidBodyPlayer and RigidBodyEntity then
        

    end
end