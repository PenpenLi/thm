
local M = class("PlayerHealth",StageDefine.HealthController)

function M:_onInit()
    M.super._onInit(self)

    self.invincibleTime = 3 --无敌时间
    self.deadSaveTime = 0.5 --x秒的决死时间
    self._isInDeadSaveState = false
    self._deadSaveElapseTime = 0

    self._invinicibleElapseTime = 0
    self._spriteNode = nil
    self._spriteNodeActionComp = nil
end
-----
function M:dying()

    --用于检测决死
    self._isInDeadSaveState = true
    self._deadSaveElapseTime = 0

    self:die()
end

function M:invincible(time)
    time = time or self.invincibleTime

    self:setInvincible(true)
end

function M:isInDeadSaveTime()
    return self._isInDeadSaveState
end

function M:deadSaveResurgence()
    print(15,"决死复活")
    
    
    self._isInDeadSaveState = false
    self._deadSaveElapseTime = 0

    --决死复活无敌一段时间,防止二次死亡
    self:invincible()
    self:reset()
end
----
function M:_onStart()
    M.super._onStart(self)
    --取得动画节点
    self._spriteNode = self:getEntity():findChild("SPRITE_NODE")
    self._spriteNodeActionComp = self._spriteNode:getComponent("ActionComponent")
end

function M:_onHurt()


end

function M:_onUpdate(delay)
    M.super._onUpdate(self,delay)
    if self:isDead() and self._isInDeadSaveState then
        self._deadSaveElapseTime = self._deadSaveElapseTime + delay
        if self._deadSaveElapseTime >= self.deadSaveTime then
            self._isInDeadSaveState = false
            self._deadSaveElapseTime = 0

            self:_onRealDead()
        end
    end
    if self:isInvincible() then
        self._invinicibleElapseTime = self._invinicibleElapseTime + delay
        if self._invinicibleElapseTime >= self.invincibleTime then
            self._invinicibleElapseTime = 0
            self:setInvincible(false)
        end
    end
end

function M:_onDead()
    --放音效表示决死计算
    print(15,"决死计时")
    --决死音效
end

function M:_onRealDead()
    print(15,"玩家死亡")
    EffectServer.playSEXEffect({
        refNode = self:getEntity(),
        source = {"ccle_player_die_magic_01"},
    })
end

function M:_onInvincible(val)
    if val then
        self._spriteNodeActionComp:runOnce(cc.Blink:create(3.0, 200))
    else  
        self._spriteNodeActionComp:stopAll()
        self._spriteNode:setVisible(true)
    end
end

return M