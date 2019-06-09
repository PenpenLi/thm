
--符卡发动时的特效
local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local uiBossComeOnNode = false
    local uiSpellCardAttackNode = false
   
    -------View-------
    local node = THSTG.UI.newNode()

    uiBossComeOnNode = require("Scripts.Context.Game.Modules.Stage.View.Components.BossComeOnEffect").create()
    node:addChild(uiBossComeOnNode)

    uiSpellCardAttackNode = require("Scripts.Context.Game.Modules.Stage.View.Components.SpellCardEffect").create()
    node:addChild(uiSpellCardAttackNode)

    local function init()
     
    end
    init()
    -------Controller-------
    local function playSpelcardEffect(_,e,params)
        uiSpellCardAttackNode:play(params)
    end

    node:onNodeEvent("enter", function ()
       Dispatcher.addEventListener(EventType.STAGE_VIEW_PREEFFECT_PLAYER_SPELLCARDATTACK, playSpelcardEffect)
    end)

    node:onNodeEvent("exit", function ()
        Dispatcher.removeEventListener(EventType.STAGE_VIEW_PREEFFECT_PLAYER_SPELLCARDATTACK, playSpelcardEffect)
    end)
    
    return node
end

return M