
local M = class("PlayerHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

   self.deadSaveTime = 0.5 --x秒的决死时间
   self._isInDeadSaveState = false
   self._elapseTime = 0
end
-----
function M:dying()

    --用于检测决死
    self._isInDeadSaveState = true
    self._elapseTime = 0
    self:die()
end

function M:isInDeadSaveTime()
    return self._isInDeadSaveState
end

function M:deadSaveResurgence()
    print(15,"决死复活")
    self._isInDeadSaveState = false
    self._elapseTime = 0
    self:reset()
end
----
function M:_onHurt()


end

function M:_onUpdate(delay)
    M.super._onUpdate(self,delay)
    if self:isDead() and self._isInDeadSaveState then
        self._elapseTime = self._elapseTime + delay
        if self._elapseTime >= self.deadSaveTime then
            self._isInDeadSaveState = false
            self._elapseTime = 0
            self:_onRealDead()
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
    SEXManager.playEffect({
        refNode = self:getEntity(),
        source = {EffectType.PUBLIC,"ccle_player_die_magic_01"},
    })
end

return M