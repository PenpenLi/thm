local M = class("BossSpellController",StageDefine.EnemySpellController)

function M:_onInit()
    M.super._onInit(self)
end

function M:bomb()
    Dispatcher.dispatchEvent(EventType.STAGE_VIEW_PREEFFECT_PLAYER_SPELLCARDATTACK,{entityData = self._baseData})
end

-------
function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M