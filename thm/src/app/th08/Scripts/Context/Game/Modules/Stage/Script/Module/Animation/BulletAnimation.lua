local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = 0                   --初始角度  
    self.centerPoint = cc.p(0.5,0.5)    --中心点
end

---
function M:_onStart()
    M.super._onStart(self)

    --进行碰撞点与贴图的位置修正
    local spriteComp = self:getComponent("SpriteComponent")
    spriteComp:setAnchorPoint(self.centerPoint)
    spriteComp:setRotation(self.rotation)
end

---
function M:_onState()
    return {
        initial = "Idle",
        events  = {
        
            {name = "Idle", from = {},  to = "Idle"},
        },
        callbacks = {
            onIdle = handler(self,self._onIdle),
        },
    }
end

function M:_onIdle(event)
    -- self:getSprite():runAction(cc.Animate:create(AnimationCache.getResBySheet("etama","bullet_big_jade_idle_4")))
end

----

return M