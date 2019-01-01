local M = class("DestroyByBullet",THSTG.ECS.Script)

function M:_onInit()
    
    
end
---
function M:_onLateUpdate()
    local system = THSTG.ECSManager.getSystem("CollisionSystem")
    if system then
        local myColliders = self:getComponents("ColliderComponent")
        for _,v in pairs(myColliders) do
            local compId = system:getGridCompId(v)
            local otherComps = system:getGridComps(compId) --取得碰撞组件
            for _,vv in pairs(otherComps) do
                if v ~= vv then
                    if vv:getEntity():getName() == "PLAYER_BULLET" then --只与玩家子弹碰撞
                        if vv:collide(v) then
                            self:getEntity():destroy()
                            vv:getEntity():destroy()
                        end
                    end
                end
            end
        end
    end
end

return M