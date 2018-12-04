module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _uiMapLayer = require("Scripts.Game.Modules.Stage.View.Layer.MapLayer").create()   --地图层
    local _uiDanmakuLayer = require("Scripts.Game.Modules.Stage.View.Layer.DanmakuLayer").create() --弹幕层
    local _uiEnemyLayer = require("Scripts.Game.Modules.Stage.View.Layer.EnemyLayer").create()  --敌机层
    local _uiPlayerLayer = require("Scripts.Game.Modules.Stage.View.Layer.PlayerLayer").create() --自机层
    local _uiScoreLayer = require("Scripts.Game.Modules.Stage.View.Layer.ScoreLayer").create()  --分数层
    local _uiStatusLayer = require("Scripts.Game.Modules.Stage.View.Layer.StatusLayer").create() --状态层-血条,对话框,符卡技能
    --




    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_uiMapLayer)
    node:addChild(_uiDanmakuLayer)
    node:addChild(_uiEnemyLayer)
    node:addChild(_uiPlayerLayer)
    node:addChild(_uiScoreLayer)
    node:addChild(_uiStatusLayer)







    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node

end

return M