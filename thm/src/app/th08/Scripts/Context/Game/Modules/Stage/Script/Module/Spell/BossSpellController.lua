local M = class("BossSpellController",StageDefine.EnemySpellController)

function M:_onInit()
    M.super._onInit(self)
end

function M:bomb()
    --TODO:触发立绘
    --TODO:触发特效
    --TODO:触发
    THSTG.Dispatcher.dispatchEvent(EventType.STAGE_SPELLCARD_EFFECT_WND,{isBoss = true,isOpen = true})
end

-------
function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M