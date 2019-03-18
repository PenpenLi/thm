module(..., package.seeall)

local M = class("StageView", THSTG.MVC.View)

function M:ctor()
    M.super.ctor(self)
    
    ----
    --背景层
    self.backgroundLayer = false
    --后置特效层
    self.backEffectLayer = false
    --实体层
    self.entityLayer = false
end

function M:_onInit()

    TestUtil.loadJsonTest("Assets/Animation/Sequence/Sheet/player00_tex.json")
end

function M:_onRealView()
    local node = THSTG.SCENE.newLayer()
    node:addTo(THSTG.SceneManager.get(SceneType.STAGE).mainLayer)

    self.backgroundLayer = cc.Layer:create()
    self.backEffectLayer = cc.Layer:create()
    self.entityLayer = cc.Layer:create()

    node:addChild(self.backgroundLayer)
    node:addChild(self.backEffectLayer)
    node:addChild(self.entityLayer)


    --游戏逻辑初始化
    local eStageGame = StageDefine.StageGame.new()
    node:addChild(eStageGame)
    
    --游戏特效层
    local bossSpellEffectWnd = require("Scripts.Context.Game.Modules.Stage.View.Effect.BossSpellCardEffectLayer").create()
    bossSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)

    local playerSpellEffectWnd = require("Scripts.Context.Game.Modules.Stage.View.Effect.PlayerSpellCardEffectLayer").create()
    playerSpellEffectWnd:addTo(THSTG.SceneManager.get(SceneType.STAGE).backEffectLayer)

    --游戏UI
    local mainUiLayer = require("Scripts.Context.Game.Modules.Stage.View.UI.StageMainLayer").create()
    mainUiLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).mainLayer)

    local statusLayer = require("Scripts.Context.Game.Modules.Stage.View.UI.StageStatusLayer").create()
    statusLayer:addTo(THSTG.SceneManager.get(SceneType.STAGE).mainLayer)

    ---
    return node
end
--
function M:addNode2Layer(layerType,node)
    
end



return M