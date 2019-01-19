module(..., package.seeall)

local M = class("StageModule", THSTG.CORE.Module)

function M:_onView()
    --游戏UI初始化
    local _eStageGame = StageDefine.StageGame.new()
    _eStageGame:addTo(THSTG.SceneManager.get(SceneType.STAGE))
    
    local _mainUiLayer = require("Scripts.Context.Game.Modules.Stage.View.UI.StageMainLayer").create()
    _mainUiLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).mainLayer)
end

function M:_onInit()
    THSTG.Dispatcher.addEventListener(EventType.STAGE_SPELLCARD_EFFECT_WND, self._spellEffectWnd, self)
end


--SpellCard特效
function M:_spellEffectWnd(e,params)
    if params.isBoss then
        if params.isOpen then
            if not self._bossSpellEffectWnd then
                local file = require("Scripts.Context.Game.Modules.Stage.View.Effect.BossSpellCardEffectLayer")
                self._bossSpellEffectWnd = file.create(params)
                self._bossSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)
            end
        else
            if self._bossSpellEffectWnd then
                self._bossSpellEffectWnd:removeFromParent()
                self._bossSpellEffectWnd = false
            end
        end     
    elseif params.isPlayer then
        if params.isOpen then
            if not self._playerSpellEffectWnd then
                local file = require("Scripts.Context.Game.Modules.Stage.View.Effect.PlayerSpellCardEffectLayer")
                self._playerSpellEffectWnd = file.create(params)
                self._playerSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)
            end
        else
            if self._playerSpellEffectWnd then
                self._playerSpellEffectWnd:removeFromParent()
                self._playerSpellEffectWnd = false
            end
        end
    end
end



return M