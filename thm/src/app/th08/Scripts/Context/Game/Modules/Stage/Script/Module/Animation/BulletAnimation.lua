local M = class("BulletAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
    self.bulletType = nil
end
--
function M:getBulletType()
    return self.bulletType
end

---
function M:_onStart()
    M.super._onStart(self)
  
    local bulletControScript = self:getScript("BulletController")
    self.bulletType = bulletControScript.bulletType
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
---
function M:_onMove(dx,dy)
    --主要根据移动方式判断动画
    -- if dx > 0 then
    --     -- self:play("MoveLeft")
    -- elseif dx < 0 then
    --     -- self:play("MoveRight")
    -- else
    --     self:play("Idle")
    -- end
end

----
function M:_onMoveLeft(event)
    
end

function M:_onMoveRight(event)
   
end

function M:_onIdle(event)
    self:getSprite():runAction(cc.Animate:create(AnimationCache.getResBySheet("player00","reimu_bullet_01_normal")))
end

----

return M