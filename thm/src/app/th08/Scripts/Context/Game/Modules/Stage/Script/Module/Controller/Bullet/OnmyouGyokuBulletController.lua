local M = class("OnmyouGyokuBulletController",StageDefine.PlayerBulletController)
local _target = nil
function M:_onInit()
    M.super._onInit(self)


    ---------
    self.searchR = 100      --搜索半径
    self.target = nil
end

function M:_onUpdate()
    -- --追踪弹
    -- if not THSTG.ECSManager.isEntityDestroyed(self.target) then self.target = nil 
    -- else
    --     if not self.target:isActive() then self.target = nil end
    -- end
    
    -- if not self.target then
    --     local entities = THSTG.ECSManager.getAllEntities()
    --     for _,entity in pairs(entities) do
    --         if entity ~= self:getEntity() then
    --             if entity:getName() == "BATMAN" then
    --                 self.target = entity
    --                 break
    --             end
    --         end
    --     end
    -- else
    --     local targetTransComp = self.target:getComponent("TransformComponent")
    --     local myTransComp = self:getComponent("TransformComponent")
    --     local direct = cc.pNormalize(cc.pSub(cc.p(targetTransComp:getPosition()),cc.p(myTransComp:getPosition())))
    --     local myRigidBodyComp = self:getComponent("RigidbodyComponent")
    --     myRigidBodyComp:setSpeed(direct.x * 10,direct.y* 10)
    -- end
end
---


return M