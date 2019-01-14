local M = class("BatmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end
---
function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
  
 
    
end
---
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "MoveLeft",  from = {"Idle","MoveRight"},  to = "MoveLeft"},
            {name = "MoveRight",  from = {"Idle","MoveLeft"},  to = "MoveRight"},

            {name = "Idle", from = {"MoveRight","MoveLeft"},  to = "Idle"},
        },
        callbacks = {
            onMoveLeft = handler(self,self._onMoveLeft),
            onMoveRight = handler(self,self._onMoveRight),
            onIdle = handler(self,self._onIdle),
        },
    }
end
---

function M:_onLateUpdate()
    --主要根据移动方式判断动画
end

----
function M:_onMoveLeft(event)
    
end

function M:_onMoveRight(event)
   
end

function M:_onIdle(event)
   
end

---
return M