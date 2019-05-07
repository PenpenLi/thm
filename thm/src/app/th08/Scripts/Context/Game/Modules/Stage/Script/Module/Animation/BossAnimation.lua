local M = class("BossAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

---
function M:getBossType()
    return self.bossType
end

function M:_onStart()
    M.super._onStart(self)

    local bossControScript = self:getScript("BossController")
    self.bossType = bossControScript.bossType
end

---
function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "MoveLeft",  from = {"Idle","MoveRight","Attack"},  to = "MoveLeft"},
            {name = "MoveRight",  from = {"Idle","MoveLeft","Attack"},  to = "MoveRight"},
            {name = "Attack",  from = {"Idle","MoveLeft","MoveRight"},  to = "Attack"},

            {name = "Idle", from = {"MoveRight","MoveLeft","Attack"},  to = "Idle"},
        },
        callbacks = {
            onAttack = handler(self,self._onAttack),
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
function M:_onAttack()
    -- self:getSprite():setFlippedX(false)
    -- self:getSprite():stopAllActions()
    -- self:getSprite():runAction(cc.Sequence:create({
    --     cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"attack"))),
    --     cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"attack_susbin"))),
    --     cc.DelayTime:create(1),
    --     cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"attack"))):reverse(),
    -- }))

end

function M:_onMoveLeft(event)
    -- self:getSprite():setFlippedX(false)
    -- self:getSprite():stopAllActions()
    -- self:getSprite():runAction(cc.Sequence:create({
    --     cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"move_right_start"))),
    --     cc.CallFunc:create(function() 
    --         self:getSprite():runAction(cc.RepeatForever:create(
    --             cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"move_right_sustain")))
    --         ))
    --     end)
    -- }))
end

function M:_onMoveRight(event)
    -- self:getSprite():setFlippedX(true )
    -- self:getSprite():stopAllActions()
    -- self:getSprite():runAction(cc.Sequence:create({
    --     cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"move_right_start"))),
    --     cc.CallFunc:create(function() 
    --         self:getSprite():runAction(cc.RepeatForever:create(
    --             cc.Animate:create(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"move_right_sustain")))
    --         ))
    --     end)
    -- }))
end

function M:_onIdle(event)
    -- local actions = {}
    -- if event.from == "MoveRight" or event.from == "MoveLeft" then
    --     local animation = AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"move_right"))
    --     animation:setDelayPerUnit(1/26)
    --     table.insert( actions,cc.Animate:create(animation):reverse())
    --     table.insert( actions,cc.CallFunc:create(function() 
    --         -- self:getSprite():setFlippedX(not self:getSprite():isFlippedX())
    --     end))
    -- end
    -- table.insert( actions,cc.CallFunc:create(function() 
    --     self:getSprite():playAnimationForever(AnimationCache.getResBySheet(StageConfig.getBossAnimSheetArgs(self:getBossType(),"stand_normal")))
    -- end))
    -- self:getSprite():stopAllActions()
    -- self:getSprite():runAction(cc.Sequence:create(actions))
end
---
return M