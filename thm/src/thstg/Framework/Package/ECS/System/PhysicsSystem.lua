module(..., package.seeall)
local M = class("PhysicsSystem",ECS.System)
M.GRAVITY_PIXEL_RATE = 1/60                        --米与像素的比率/每帧
M.GRAVITY = 9.8                                    --重力加速度

function M:_onInit()
    --消息注册
end

function M:_onFrameUpdate(delay)
    local rigidbodyComps = self:getComponents("RigidbodyComponent")
    for _,vRigidComp in pairs(rigidbodyComps) do
        --重力加速度叠加
        if vRigidComp:isGravityEnabled() then
            local retForce = cc.p(0, -M.GRAVITY * vRigidComp.gravityScale)
            vRigidComp:addForce(retForce)
        end
        --加速度叠加
        local accSpeed = cc.p(vRigidComp.retForce.x/vRigidComp.mass,vRigidComp.retForce.y/vRigidComp.mass)
        vRigidComp.speed.x = vRigidComp.speed.x + accSpeed.x * M.GRAVITY_PIXEL_RATE        
        vRigidComp.speed.y = vRigidComp.speed.y + accSpeed.y * M.GRAVITY_PIXEL_RATE       

        local vTransComp = vRigidComp:getEntity():getComponent("TransformComponent")
        vTransComp:setPositionX(vTransComp:getPositionX() + vRigidComp.speed.x)
        vTransComp:setPositionY(vTransComp:getPositionY() + vRigidComp.speed.y)

        -- 非持续力,每帧清空
        vRigidComp.retForce = cc.p(0,0)
    end
end


return M