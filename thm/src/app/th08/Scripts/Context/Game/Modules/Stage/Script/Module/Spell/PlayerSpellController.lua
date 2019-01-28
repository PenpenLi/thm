local M = class("PlayerSpellController",StageDefine.SpellController)

function M:_onInit()
    M.super._onInit(self)
    self.maxBombCount = 3                               --Bomb次数
    self.curBombCount = self.maxBombCount               --当前可用次数


end
-------
function M:bomb()
    if self.curBombCount <= 0 then return end
    print(15,"炸弹")

    self.curBombCount = self.curBombCount - 1
    --TODO:决死效果

    THSTG.Dispatcher.dispatchEvent(EventType.STAGE_PLAYER_SPELLCARD_ATTACK,{roleType = self.roleType,isDeadSave = false})
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

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M