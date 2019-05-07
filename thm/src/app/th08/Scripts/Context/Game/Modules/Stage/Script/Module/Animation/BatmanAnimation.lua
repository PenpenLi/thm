local M = class("BatmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)

end
--

---
function M:_onStart()
    M.super._onStart(self)

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
function M:_onMove(dx,dy)
    --主要根据移动方式判断动画
    if dx > 0 then
        self:play("MoveLeft")
    elseif dx < 0 then
        self:play("MoveRight")
    else
        self:play("Idle")
    end
end

----
function M:_onMoveLeft(event)
    -- self:getSprite():setFlippedX(true)
    -- self:getSprite():stopAllActions()
    -- local actions = {}
    -- if event.from == "MoveRight" or event.from == "MoveLeft" then
    --     local animation = AnimationCache.getResBySheet(StageConfig.getBatmanAnimSheetArgs(self:getBatmanType(),"move_turn"))
    --     table.insert(actions,cc.Animate:create(animation))
    -- end
    -- table.insert(actions,cc.CallFunc:create(function() 
    --     self:getSprite():runAction(cc.RepeatForever:create(
    --         cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBatmanAnimSheetArgs(self:getBatmanType(),"move_right")))
    --     ))
    -- end))
    -- self:getSprite():runAction(cc.Sequence:create(actions))
end

function M:_onMoveRight(event)
    -- self:getSprite():setFlippedX(false)
    -- self:getSprite():stopAllActions()
    -- local actions = {}
    -- if event.from == "MoveRight" or event.from == "MoveLeft" then
    --     local animation = AnimationCache.getResBySheet(StageConfig.getBatmanAnimSheetArgs(self:getBatmanType(),"move_turn"))
    --     table.insert(actions,cc.Animate:create(animation))
    -- end
    -- table.insert(actions,cc.CallFunc:create(function() 
    --     self:getSprite():runAction(cc.RepeatForever:create(
    --         cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBatmanAnimSheetArgs(self:getBatmanType(),"move_right")))
    --     ))
    -- end))
    -- self:getSprite():runAction(cc.Sequence:create(actions))
end

function M:_onIdle(event)
    -- local actions = {}
  
    -- table.insert( actions,cc.CallFunc:create(function() 
    --     self:getSprite():playAnimationForever(AnimationCache.getResBySheet(StageConfig.getBatmanAnimSheetArgs(self:getBatmanType(),"stand_normal")))
    -- end))
    -- self:getSprite():stopAllActions()
    -- self:getSprite():runAction(cc.Sequence:create(actions))
end

--
return M