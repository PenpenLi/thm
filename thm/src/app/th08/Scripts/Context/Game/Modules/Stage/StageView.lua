module(..., package.seeall)

local M = class("StageView", THSTG.MVC.View)

function M:_onInit()
    --游戏逻辑初始化
    local _eStageGame = StageDefine.StageGame.new()
    _eStageGame:addTo(THSTG.SceneManager.get(SceneType.STAGE))
    
    --游戏特效层
    local bossSpellEffectWnd = require("Scripts.Context.Game.Modules.Stage.View.Effect.BossSpellCardEffectLayer").create()
    bossSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)
    local playerSpellEffectWnd = require("Scripts.Context.Game.Modules.Stage.View.Effect.PlayerSpellCardEffectLayer").create()
    playerSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)

    --游戏UI
    local _mainUiLayer = require("Scripts.Context.Game.Modules.Stage.View.UI.StageMainLayer").create()
    _mainUiLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).mainLayer)
end

--
function M:addNode2Layer(layerType,node)
    
end



return M