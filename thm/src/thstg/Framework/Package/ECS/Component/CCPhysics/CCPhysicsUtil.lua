
module(..., package.seeall)

function isCCPhysicsWorld(comp)
    local isAdded = comp:isAdded()
    if isAdded then
        local scene = comp:getEntity():getScene()
        if isAdded and scene and scene:getPhysicsWorld() then
            return true
        end
    end
    return false
end


function copyPhysicsBodyProps(oldPhysics,newPhysics)
    if not oldPhysics or not newPhysics or oldPhysics == newPhysics then return end
    --重力,感应区,速度质量,摩擦力,等所有状态
    newPhysics:setVelocity(oldPhysics:getVelocity())
    newPhysics:setGravityEnable(oldPhysics:isGravityEnabled())
    
end