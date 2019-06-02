local M = class("PlayerSpellController",StageDefine.SpellController)

function M:_onInit()
    M.super._onInit(self)
    self.maxBombCount = 3                               --Bomb次数
    self.curBombCount = self.maxBombCount               --当前可用次数

    self.healthCtrl = nil
end
-------
function M:bomb()
    if self.curBombCount <= 0 then return end
    print(15,"炸弹")

    self.curBombCount = self.curBombCount - 1
    local isDeadSave = self.healthCtrl:isInDeadSaveTime()
    if isDeadSave then
        self.curBombCount = math.min(0,self.curBombCount - 1)   --再次消耗一个
        self.healthCtrl:deadSaveResurgence()-- 重新赋予生命
    end
    Dispatcher.dispatchEvent(EventType.STAGE_VIEW_PREEFFECT_PLAYER_SPELLCARDATTACK,{entityData = self._baseData,isDeadSave = isDeadSave})
end

function M:reset()
    
end

function M:getRestCount()
    return self.curBombCount
end

function M:setRestCount(val)
    self.curBombCount = val
end
-------
function M:_onStart()
    M.super._onStart(self)
    self.healthCtrl = self:getScript("PlayerHealth")
end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M