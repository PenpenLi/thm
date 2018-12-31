local M = class("PlayerCollision",THSTG.ECS.Script)

function M:_onInit()

end

function M:_onLateUpdate()
    local system = THSTG.ECSManager.getSystem("CollisionSystem")
    if system then
        local myColliders = self:getComponents("ColliderComponent")
        for _,v in pairs(myColliders) do
            local compId = system:getGridCompId(v)
            local otherComps = system:getGridComps(compId) --取得碰撞组件
            for _,vv in pairs(otherComps) do
                if v ~= vv then
                    if vv:getEntity():getName() ~= "PLAYER_BULLET" then --不与自己的子弹碰撞
                        if vv:collide(v) then
                            print(15,"collide")
                        end
                    end
                end
            end
        end
    end
end

return M