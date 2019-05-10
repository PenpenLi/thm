module(..., package.seeall)

local M = class("StageView", THSTG.MVC.View)

function M:ctor()
    M.super.ctor(self)
    
    self._stageGame = false
    self._backgroundLayer = false
    self._backEffectLayer = false
    self._preEffectLayer = false
end

function M:_onInit()


end

function M:_onRealView()
    --游戏逻辑初始化
    self._stageGame = StageDefine.StageGame.new()
    self._stageGame:addTo(THSTG.SceneManager.get(SceneType.MAIN))

    --背景层
    self._backgroundLayer = require("Scripts.Context.Game.Modules.Stage.View.StageBackgroundLayer").create()
    self._backgroundLayer:addTo(THSTG.SceneManager.get(SceneType.MAIN).backgroundLayer)

    --后置特效层
    self._backEffectLayer = require("Scripts.Context.Game.Modules.Stage.View.StageBackEffectLayer").create()
    self._backEffectLayer:addTo(THSTG.SceneManager.get(SceneType.MAIN).backgroundLayer)

    --前置特效层
    self._preEffectLayer = require("Scripts.Context.Game.Modules.Stage.View.StagePreEffectLayer").create()
    self._preEffectLayer:addTo(THSTG.SceneManager.get(SceneType.MAIN).backgroundLayer)
end

function M:addEntity2Layer(entity)
    if entity then
        local baseData = entity:getScript("EntityBasedata")
        if baseData then
            local entityType = baseData:getEntityType()
            local layer = EntityLayerMapConfig.tryGetLayer(entityType)
            if layer then
                entity:addTo(layer)
            end
        end
    end
end

return M