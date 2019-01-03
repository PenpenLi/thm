local M = class("BulletController",THSTG.ECS.Script)

function M:_onInit()
    self.belong = 0
    self.type = false
    self.speed = cc.p(0,10)     --正方向为上
    self.rotation = 0
end

--
function M:stopMove()
    self.speed = cc.p(0,0)
end

function M:setSpeed(x,y)
    self.speed = cc.p(x,y)
end
--
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite
    sprite:runAction(cc.Animate:create(AnimationCache.getSheetRes("reimu_bullet_01_normal")))
    sprite:setAnchorPoint(cc.p(0.875,0.5))
    sprite:setRotation(self.rotation)
    
end
---
function M:_onUpdate(delay)
    self:_moveHandle()


end

function M:_onLateUpdate()
    self:_collideHandle()
end
--
function M:__onCollide(collider)
    local colliderScript = collider:getScript("HealthController")--被击中物
    colliderScript:hurt(3)--TODO:伤害值由计算得出
    
    local myScript = self:getScript("HealthController")         --被击中物
    myScript:hurt(9999)--TODO:伤害值由计算得出
    self.speed = cc.p(0,0)  --停止运动
end

-----
function M:_moveHandle()
    local posComp = self:getComponent("TransformComponent")
    posComp:setPositionY(posComp:getPositionY() + self.speed.y)
end

function M:_collideHandle()
    local system = self:getSystem("CollisionSystem")
    if system then
        --某些条件下,不在进行碰撞检测
        local myScript = self:getScript("HealthController")         --被击中物
        if not myScript:isDead() then
            local isCollide,collision = system:isCollided(self:getEntity(),{"PLAYER_BULLET","PLAYER"})
            if isCollide then self:__onCollide(collision.collider) end
        end
    end
end


return M