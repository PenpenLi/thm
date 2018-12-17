module(..., package.seeall)
local M = class("CollisionSystem",THSTG.ECS.System)
function M:_onAdded()
    local rigidbodyComp = self:getComponent("RigidbodyComponent")

    local animationComp = self:getComponent("AnimationComponent")
    animationComp.sprite:setAnchorPoint(0.5,0.5)
    animationComp.sprite:setContentSize(cc.size(rigidbodyComp.body.width,rigidbodyComp.body.height))
end


return M