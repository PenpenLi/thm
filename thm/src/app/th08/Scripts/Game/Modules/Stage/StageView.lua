module(..., package.seeall)

local M = class("StageView", View)

function M:_onInit()
    self:setLayer(LayerManager.guiLayer)
    
    --
    --地图层
    self.__mapLayer = false
    --弹幕层
    self.__danmakuLayer = false
    --敌机层
    self.__enemyLayer = false
    --自机层
    self.__playerLayer = false
    --分数层
    self.__scoreLayer = false
    --状态层-血条,对话框,符卡技能
    self.__statusLayer = false
end

function M:_initRealView(params)
    local layer = cc.Layer:create()

    self.__mapLayer = require("Scripts.Game.Modules.Stage.Layer.StageMapLayer").create()
    layer:addChild(self.__mapLayer)

    self.__danmakuLayer = require("Scripts.Game.Modules.Stage.Layer.StageDanmakuLayer").create()
    layer:addChild(self.__danmakuLayer)

    self.__enemyLayer = require("Scripts.Game.Modules.Stage.Layer.StageEnemyLayer").create()
    layer:addChild(self.__enemyLayer)

    self.__playerLayer = require("Scripts.Game.Modules.Stage.Layer.StagePlayerLayer").create()
    layer:addChild(self.__playerLayer)

    self.__scoreLayer = require("Scripts.Game.Modules.Stage.Layer.StageScoreLayer").create()
    layer:addChild(self.__scoreLayer)

    self.__statusLayer = require("Scripts.Game.Modules.Stage.Layer.StageStatusLayer").create()
    layer:addChild(self.__statusLayer)

    return layer
end

return M