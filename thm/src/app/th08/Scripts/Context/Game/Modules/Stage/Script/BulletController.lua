local M = class("BulletController",THSTG.ECS.Script)

function M:_onInit()
    self.belong = 0
    self.type = false
    self.speed = cc.p(0,10)     --正方向为上
    self.rotation = 0
end
--
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite
    sprite:setRotation(self.rotation)
    
    sprite:runAction(cc.RepeatForever:create(
        cc.Animate:create(AnimationCache.getSheetRes("reimu_bullet_01_normal"))
    ))
 
    
end

function M:_moveHandle()
    local posComp = self:getComponent("TransformComponent")
    posComp:setPositionY(posComp:getPositionY() + self.speed.y)
end

function M:_collideHandle()
    local system = THSTG.ECSManager.getSystem("CollisionSystem")
    if system then
        local myColliders = self:getComponents("ColliderComponent")
        for _,v in pairs(myColliders) do
            local compId = system:getGridCompId(v)
            local otherComps = system:getGridComps(compId) --取得碰撞组件
            for _,vv in pairs(otherComps) do
                while true do
                    if v ~= vv then
                        if vv:getEntity():getName() == "PLAYER_BULLET" then break       --不与玩家子弹碰撞
                        elseif vv:getEntity():getName() == "PLAYER" then break          --不与玩家碰撞
                        end          

                        if v:collide(vv) then
                            vv:getEntity():destroy()
                            v:getEntity():destroy()
                        end
                    end
                    break
                end
                
            end
        end
    end
end
---
function M:_onUpdate(delay)
    self:_moveHandle()


end

function M:_onLateUpdate()
    self:_collideHandle()
end

return M