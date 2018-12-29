local M = class("PlayerCollision",THSTG.ECS.Script)

function M:_onInit()

end

function M:_onLateUpdate()
    -- local entities = THSTG.ECS.Entity.getAllEx(self:getEntity())
    -- local myCollComp = self:getComponent("ColliderComponent")
    -- for _,v in pairs(entities) do
    --     local entityCollComp = v:getComponent("ColliderComponent")
    --     if entityCollComp then
    --         if cc.rectIntersectsRect(myCollComp.rect,entityCollComp.rect) then
    --             --TODO:碰撞
    --         end
    --     end
    -- end
end

return M