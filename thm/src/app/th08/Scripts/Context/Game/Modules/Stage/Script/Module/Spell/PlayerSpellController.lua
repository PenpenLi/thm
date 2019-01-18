local M = class("PlayerSpellController",StageDefine.BaseSpellController)

function M:_onInit()
    M.super._onInit(self)
    self.bombCount = 3                              --Bomb次数
end
-------
function M:bomb()
    --TODO:触发特效
    --TODO:触发
    THSTG.Dispatcher.dispatchEvent(EventType.STAGE_SPELLCARD_EFFECT_WND,{isPlayer = true,isOpen = true})
end

-------
function M:_onStart()

end

function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M